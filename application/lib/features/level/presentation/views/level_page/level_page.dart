import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'level_page_error.dart';
import 'level_page_loader.dart';

final class LevelPage extends ConsumerStatefulWidget {
  static const routePath = '/levels/:id';

  final int id;

  const LevelPage({super.key, required this.id});

  @override
  ConsumerState createState() {
    return _LevelPageState();
  }
}

final class _LevelPageState extends ConsumerState<LevelPage> {
  final answerFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(checkAnswerMutationProvider, (prev, next) {
      if (prev?.hasError != true && next.hasError) {
        showSnackbar(context, next.error ?? 'levels.error_checking'.tr());
      }
    });
  }

  @override
  void dispose() {
    answerFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(levelControllerProvider(widget.id).notifier);
    final asyncValue = ref.watch(levelControllerProvider(widget.id));

    return asyncValue.when(
      data: (data) {
        final LevelData(:level, :count) = data;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,

            titleSpacing: 8.0,
            title: Text('levels.level'.tr(namedArgs: {'id': '${level.id}'})),

            leadingWidth: 60.0,
            leading: const PopButton(),

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

          body: Center(
            child: Text(
              level.question.resolve(),
              textAlign: level.question.type == QuestionType.code
                  ? TextAlign.start
                  : TextAlign.center,
            ),
          ).padded(const EdgeInsets.symmetric(horizontal: 64.0)),

          bottomNavigationBar: LevelInput(
            onSubmit: () async {
              final match = await controller.checkAnswer(
                answerFieldController.text,
              );

              if (!match) {
                showSnackbar(context, 'levels.wrong_answer'.tr());
                return;
              }

              final soundEffects = ref
                  .read(appConfigRepositoryProvider)
                  .soundEffects;

              await showLevelCompletedDialog(
                context,
                soundEffects: soundEffects,
                rootNavigator: false,
              );

              answerFieldController.clear();

              if (level.id < count) {
                await ref
                    .read(goRouterProvider)
                    .replace('/levels/${level.id + 1}');
              } else {
                ref.read(goRouterProvider).pop(true);
              }
            },
            onAdd: (char) {
              addItem(char);
            },
            onClear: () {
              clearAnswer();
            },

            controller: answerFieldController,
            items: level.options,
          ).dismissKeyboard(context),
        );
      },

      loading: () {
        return const LevelPageLoader();
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
    answerFieldController.text += item;
  }

  void clearAnswer() {
    answerFieldController.clear();
  }
}
