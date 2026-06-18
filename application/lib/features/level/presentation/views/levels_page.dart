import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class LevelsPage extends ConsumerStatefulWidget {
  static const routePath = '/levels';

  const LevelsPage({super.key});

  @override
  ConsumerState createState() {
    return LevelsPageState();
  }
}

final class LevelsPageState extends ConsumerState<LevelsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final _ = ref.read(levelsControllerProvider.notifier);
    final asyncValue = ref.watch(levelsControllerProvider);

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: Text('levels.title'.tr()),

        leadingWidth: 48.0,
        leading: const PopButton(),
      ),

      body: SafeArea(
        child: asyncValue.when(
          data: (data) {
            final (:levels, :currentLevel) = data;

            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
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
                    textStyle: WidgetStateProperty.resolveWith(
                      (states) => theme.textTheme.bodyMedium?.copyWith(
                        color: states.contains(WidgetState.disabled)
                            ? theme.colorScheme.onSurfaceVariant.withValues(
                                alpha: 0.25,
                              )
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  icon: Text('${index + 1}'),
                );
              },
            );
          },
          error: (e, s) {
            return Text('levels.error_loading_all'.tr()).centered();
          },
          loading: () {
            return const CircularProgressIndicator.adaptive().centered();
          },
        ),
      ),
    );
  }
}
