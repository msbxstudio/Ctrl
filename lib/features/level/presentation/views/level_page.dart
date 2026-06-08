import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/shared/dialogs/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:lucide_icons/lucide_icons.dart';

final class LevelPage extends ConsumerStatefulWidget {
  static const routePath = '/levels/:id';

  final int id;

  const LevelPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LevelPageState();
  }
}

final class LevelPageState extends ConsumerState<LevelPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _answerFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(checkAnswerMutationProvider, (prev, next) {
      if (prev?.hasError != true && next.hasError) {
        showSnackbar(context, next.error ?? 'Error checking answer');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controllerProvider = levelControllerProvider(widget.id);

    final controller = ref.read(controllerProvider.notifier);
    final asyncValue = ref.watch(controllerProvider);

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: asyncValue.hasValue ? Text('Level ${widget.id}') : null,

        leadingWidth: 48.0,
        leading: const PopButton(),

        actions: [
          IconButton(
            onPressed: asyncValue.hasValue
                ? () async {
                    await showHintDialog(context, hint: 'x + 1');
                  }
                : null,
            tooltip: 'Hint',

            icon: const Icon(TablerIcons.bulb_filled),
          ),
        ],
      ),

      body: asyncValue
          .when(
            data: (data) {
              final LevelData(:level) = data;

              return Text(
                level.question,
                textAlign: TextAlign.center,
              ).centered();
            },
            error: (_, _) {
              return const Text('Error loading level').centered();
            },
            loading: () {
              return const CircularProgressIndicator().centered();
            },
          )
          .padded(const EdgeInsets.symmetric(horizontal: 64.0)),

      bottomNavigationBar: Theme(
        data: theme.copyWith(
          filledButtonTheme: FilledButtonThemeData(
            style: theme.filledButtonTheme.style?.copyWith(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),

        child: SafeArea(
          child: asyncValue.maybeWhen(
            data: (data) {
              final (:level) = data;

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 4.0,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8.0,

                    children: [
                      TextFormField(
                        readOnly: true,
                        controller: _answerFieldController,

                        decoration: InputDecoration(
                          hintText: 'Answer',
                          suffixIcon: IconButton(
                            onPressed: _clearAnswer,

                            style: theme.iconButtonTheme.style?.copyWith(
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),

                              foregroundColor: WidgetStateProperty.resolveWith(
                                (states) => states.contains(WidgetState.pressed)
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),

                            icon: const Icon(LucideIcons.x),
                          ),
                        ),
                      ).expand(flex: 31),

                      FilledButton.tonal(
                        onPressed: () async {
                          final match = controller.checkAnswer(
                            _answerFieldController.text,
                          );

                          if (match) {
                            _answerFieldController.clear();
                            ref
                                .read(goRouterProvider)
                                .replace('/levels/${widget.id + 1}');
                          } else {
                            showSnackbar(context, 'Respuesta incorrecta.');
                          }
                        },

                        child: Text('ENTER'),
                      ).expand(flex: 20),
                    ],
                  ),
                  ..._keyboard(options: level.options),
                ],
              );
            },
            orElse: () {
              return const SizedBox.shrink();
            },
          ),
        ),
      ).padded(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
    ).dismissKeyboard(context);
  }

  List<Widget> _keyboard({required List options}) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,

        children: options
            .take(5)
            .map(
              (it) => FilledButton.tonal(
                onPressed: () => _addItem('$it'),

                child: Text('$it'),
              ).expand(),
            )
            .toList(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,

        children: options
            .skip(5)
            .map(
              (it) => FilledButton.tonal(
                onPressed: () => _addItem('$it'),

                child: Text('$it', textAlign: TextAlign.center),
              ).expand(),
            )
            .toList(),
      ),
    ];
  }

  void _addItem(String item) {
    _answerFieldController.text += item;
  }

  void _clearAnswer() {
    _answerFieldController.clear();
  }
}
