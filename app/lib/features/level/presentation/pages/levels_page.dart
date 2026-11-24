import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:msbx/config.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/shared/widgets.dart';

import 'levels_page_error.dart';
import 'levels_page_skeleton.dart';

final class LevelsPage extends ConsumerStatefulWidget {
  const new({super.key});

  static const routePath = '/levels';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _LevelsPageState();
  }
}

final class _LevelsPageState extends ConsumerState<LevelsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(levelsControllerProvider.notifier);
    final value = ref.watch(levelsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: Text('levels.title'.tr()),

        leadingWidth: 64.0,
        leading: const NavigationButton.back(),
      ),

      body: SafeArea(
        child: value.when(
          loading: () {
            return const LevelsPageSkeleton();
          },

          error: (err, _) {
            return LevelsPageError(
              onRetry: () async {
                await controller.refresh();
              },
              error: err,
            );
          },

          data: (state) {
            final theme = Theme.of(context);

            final LevelsState(:levels, :currentLevel) = state;

            return LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxWidth;
                final remaining = width - Breakpoints.small;

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: remaining <= 16.0 ? 16.0 : remaining / 2,
                    vertical: 12.0,
                  ),

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.0,
                  ),

                  itemCount: levels.length,
                  itemBuilder: (_, index) {
                    final enabled =
                        currentLevel == null || index + 1 <= currentLevel.id;

                    return OutlinedButton(
                      onPressed: enabled
                          ? () async {
                              await ref
                                  .read(routerProvider)
                                  .push('/levels/${levels[index].id}');
                            }
                          : null,

                      style: theme.iconButtonTheme.style?.copyWith(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: enabled
                                ? theme.colorScheme.outlineVariant.withValues(
                                    alpha: 0.9,
                                  )
                                : theme.colorScheme.outline.withValues(
                                    alpha: 0.1,
                                  ),
                            width: 1.0,
                          ),
                        ),
                      ),

                      child: Text(
                        '${index + 1}',

                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: enabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
