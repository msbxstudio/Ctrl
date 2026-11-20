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
  static const routePath = '/levels';

  const LevelsPage({super.key});

  @override
  ConsumerState createState() {
    return _LevelsPageState();
  }
}

final class _LevelsPageState extends ConsumerState<LevelsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controller = ref.read(levelsControllerProvider.notifier);
    final asyncValue = ref.watch(levelsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: Text('levels.title'.tr()),

        leadingWidth: 64.0,
        leading: const PopButton.back(),
      ),

      body: SafeArea(
        child: asyncValue.when(
          data: (data) {
            final LevelsState(:levels, :currentLevel) = data;

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
                    final level = levels[index];

                    return IconButton(
                      onPressed: index + 1 <= currentLevel.id
                          ? () async {
                              await ref
                                  .read(routerProvider)
                                  .push('/levels/${level.id}');
                            }
                          : null,

                      style: theme.iconButtonTheme.style?.copyWith(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                            width: 1.0,
                          ),
                        ),
                        textStyle: WidgetStateProperty.resolveWith((states) {
                          return theme.textTheme.bodyMedium?.copyWith(
                            color: states.contains(WidgetState.disabled)
                                ? theme.colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.25,
                                  )
                                : theme.colorScheme.onSurfaceVariant,
                          );
                        }),
                      ),

                      icon: Text('${index + 1}'),
                    );
                  },
                );
              },
            );
          },
          error: (e, _) {
            return LevelsPageError(
              onRetry: () async {
                await controller.refresh();
              },
              error: e,
            );
          },
          loading: () {
            return const LevelsPageSkeleton();
          },
        ),
      ),
    );
  }
}
