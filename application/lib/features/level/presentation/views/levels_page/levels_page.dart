import 'package:ctrl/app/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'levels_page_error.dart';
import 'levels_page_loader.dart';

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

        leadingWidth: 60.0,
        leading: const PopButton(),
      ),

      body: SafeArea(
        child: asyncValue.when(
          data: (data) {
            final LevelsData(:levels, :currentLevel) = data;

            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
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
                              .read(goRouterProvider)
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
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.5),
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
          error: (e, _) {
            return LevelsPageError(
              onRetry: () async {
                await controller.refresh();
              },
              error: e,
            );
          },
          loading: () {
            return const LevelsPageLoader();
          },
        ),
      ),
    );
  }
}
