import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/utils/index.dart';
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
  final _formKey = GlobalKey<FormState>();

  final _answerFieldController = TextEditingController();

  final _correctAnswer = '1234';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: Text('Level ${widget.id}'),

        leadingWidth: 48.0,
        leading: const PopButton(),

        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Hint',

            icon: const Icon(TablerIcons.bulb_filled),
          ),
        ],
      ),

      body: Form(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16.0,

          children: [const Text('Level Page')],
        ).padded(const EdgeInsets.symmetric(horizontal: 12.0)),
      ).centered(),

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

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 4.0,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,

              children: [
                Form(
                  key: _formKey,

                  child: TextFormField(
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
                  ),
                ).expand(flex: 31),

                FilledButton.tonal(
                  onPressed: _sendAnswer,

                  child: Text('ENTER'),
                ).expand(flex: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,

              children: const <int>[1, 2, 3, 4, 5]
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

              children: const <int>[6, 7, 8, 9, 0]
                  .map(
                    (it) => FilledButton.tonal(
                      onPressed: () => _addItem('$it'),

                      child: Text('$it'),
                    ).expand(),
                  )
                  .toList(),
            ),
          ],
        ),
      ).padded(const EdgeInsets.all(12.0)),
    ).dismissKeyboard(context);
  }

  void _addItem(String item) {
    _answerFieldController.text += item;
  }

  void _sendAnswer() {
    if (!_formKey.currentState!.validate()) return;

    if (_answerFieldController.text == _correctAnswer) {
      Debugger.log('Correct answer!');
    } else {
      showSnackbar(context, 'Incorrect answer!');
    }
  }

  void _clearAnswer() {
    _answerFieldController.clear();
  }
}
