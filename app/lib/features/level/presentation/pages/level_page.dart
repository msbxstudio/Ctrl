import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/core/helpers.dart';
import 'package:ctrl/core/utils.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

import 'level_page_error.dart';
import 'level_page_skeleton.dart';

/// Displays the puzzle associated with a specific level.
///
/// Manages the player's answer input and provides access to
/// Riverpod providers within its state.
final class LevelPage extends ConsumerStatefulWidget {
  /// Creates a page for the level identified by [id].
  const new({
    super.key,
    required this.id,
  });

  /// The route pattern containing the level identifier as a path parameter.
  static const routePath = '/levels/:id';

  /// The identifier of the level to display.
  final int id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LevelPageState();
  }
}

/// Manages the mutable state and answer input of [LevelPage].
final class _LevelPageState extends ConsumerState<LevelPage> {
  /// Controls the text representing the player's current answer.
  late final TextEditingController _answerFieldController;

  void _addItem(String item) {
    _answerFieldController.text += item;
  }

  void _clearAnswer() {
    _answerFieldController.clear();
  }

  @override
  void initState() {
    super.initState();

    _answerFieldController = TextEditingController();

    ref.listenManual(checkAnswerMutationProvider, (prev, next) {
      if (prev?.hasError != true && next.hasError) {
        final error = next.error;

        showSnackbar(
          context,
          errorMessage(error, fallbackKey: 'errors.levels.check_answer'),
        );
      }
    });
  }

  @override
  void dispose() {
    _answerFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = levelControllerProvider(widget.id);

    final controller = ref.read(provider.notifier);
    final value = ref.watch(provider);

    return value.when(
      loading: () {
        return const LevelPageSkeleton();
      },

      error: (err, _) {
        return LevelPageError(
          onRetry: () async {
            await controller.refresh();
          },
          error: err,
        );
      },

      data: (state) {
        final LevelState(:level, :count) = state;

        final padding = EdgeInsets.symmetric(
          horizontal: responsiveHorizontalPadding(context),
        );

        return Scaffold(
          appBar: TopAppBar(
            title: Text('levels.label'.tr(namedArgs: {'id': '${level.id}'})),

            leading: Padding(
              padding: padding.copyWith(right: 0.0),
              child: const NavigationButton.back(
                result: true,
              ),
            ),

            trailing: Padding(
              padding: padding.copyWith(left: 0.0),
              child: NavigationButton(
                onPressed: () async {
                  await showHintDialog(
                    context,
                    hint: level.hint != null
                        ? level.hint!.resolve()
                        : 'levels.no_hint'.tr(),
                  );
                },

                tooltip: 'levels.hint_tooltip'.tr(),
                child: const Icon(TablerIcons.bulb),
              ),
            ),
          ),

          body: Text(
            level.question.resolve(),
            textAlign: switch (level.question.type) {
              QuestionType.code => TextAlign.start,
              _ => TextAlign.center,
            },
          ).centered(),

          bottomNavigationBar: SafeArea(
            minimum: padding.copyWith(top: 12.0, bottom: 12.0),

            child: AnswerInput(
              onSubmit: () async {
                final match = await controller.checkAnswer(
                  _answerFieldController.text,
                );

                if (!mounted) return;

                // The mutation listener already displays persistence errors.
                if (ref.read(checkAnswerMutationProvider).hasError) {
                  return;
                }

                if (!match) {
                  return showSnackbar(
                    context,
                    'levels.wrong_answer'.tr(),
                  );
                }

                final allowSounds = ref
                    .read(preferencesNotifierProvider)
                    .allowSounds;

                await showLevelCompletedDialog(
                  context,
                  allowSounds: allowSounds,
                  rootNavigator: false,
                );

                _answerFieldController.clear();

                if (level.id < count) {
                  await ref
                      .read(routerProvider)
                      .replace('/levels/${level.id + 1}');
                } else {
                  ref.read(routerProvider).pop(true);
                }
              },

              onAdd: (char) {
                _addItem(char);
              },

              onClear: () {
                _clearAnswer();
              },

              items: level.options,
              controller: _answerFieldController,
            ),
          ),
        ).dismissKeyboard(context);
      },
    );
  }
}
