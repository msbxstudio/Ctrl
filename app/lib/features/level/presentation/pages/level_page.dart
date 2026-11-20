import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:msbx/config.dart';
import 'package:msbx/exceptions.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

import 'level_page_error.dart';
import 'level_page_skeleton.dart';

final class LevelPage extends ConsumerStatefulWidget {
  const new({super.key, required this.id});

  static const routePath = '/levels/:id';

  final int id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LevelPageState();
  }
}

final class _LevelPageState extends ConsumerState<LevelPage> {
  late final TextEditingController _answerFieldController;

  @override
  void initState() {
    super.initState();

    _answerFieldController = TextEditingController();

    ref.listenManual(checkAnswerMutationProvider, (prev, next) {
      if (prev?.hasError != true && next.hasError) {
        final error = next.error;

        showSnackbar(
          context,
          error is AppException ? error.message : 'levels.error_checking'.tr(),
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
    final controller = ref.watch(levelControllerProvider(widget.id).notifier);
    final asyncValue = ref.watch(levelControllerProvider(widget.id));

    return asyncValue.when(
      data: (state) {
        final LevelState(:level, :count) = state;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,

            titleSpacing: 12.0,
            title: Text('levels.level'.tr(namedArgs: {'id': '${level.id}'})),

            leadingWidth: 64.0,
            leading: const PopButton.back(),

            actionsPadding: const EdgeInsets.only(right: 18.0),
            actions: [
              IconButton(
                onPressed: () async {
                  await showHintDialog(
                    context,
                    hint: level.hint != null
                        ? level.hint!.resolve()
                        : 'levels.no_hint'.tr(),
                  );
                },
                tooltip: 'levels.hint_tooltip'.tr(),

                icon: const Icon(TablerIcons.bulb_filled),
              ),
            ],
          ),

          body:
              Text(
                    level.question.resolve(),
                    textAlign: level.question.type == QuestionType.code
                        ? TextAlign.start
                        : TextAlign.center,
                  )
                  .constrained(maxWidth: 600.0)
                  .centered()
                  .padded(const EdgeInsets.symmetric(horizontal: 64.0)),

          bottomNavigationBar: LevelInput(
            onSubmit: () async {
              final match = await controller.checkAnswer(
                _answerFieldController.text,
              );

              if (!match) {
                showSnackbar(context, 'levels.wrong_answer'.tr());
                return;
              }

              final soundEffects = ref
                  .read(preferencesNotifierProvider)
                  .allowSounds;

              await showLevelCompletedDialog(
                context,
                soundEffects: soundEffects,
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
              addItem(char);
            },
            onClear: () {
              clearAnswer();
            },

            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            controller: _answerFieldController,
            items: level.options,
          ).constrained(maxWidth: Breakpoints.small).aligned(Alignment.center),
        ).dismissKeyboard(context);
      },

      loading: () {
        return const LevelPageSkeleton();
      },

      error: (error, _) {
        return LevelPageError(
          onRetry: () async {
            await controller.refresh();
          },
          error: error,
        );
      },
    );
  }

  void addItem(String item) {
    _answerFieldController.text += item;
  }

  void clearAnswer() {
    _answerFieldController.clear();
  }
}
