import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:msbx/config.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/utils.dart';
import 'package:msbx/widgets.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/features/home.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

import 'home_page_error.dart';
import 'home_page_skeleton.dart';

final class HomePage extends ConsumerStatefulWidget {
  ///
  const new({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomePageState();
  }
}

final class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext _) {
    final controller = ref.read(homeControllerProvider.notifier);
    final value = ref.watch(homeControllerProvider);

    return value.when(
      loading: () {
        return const HomePageSkeleton();
      },
      error: (err, _) {
        return HomePageError(
          onRetry: () async {
            await controller.refresh();
          },
          error: err,
        );
      },
      data: (state) {
        final HomeState(
          :player,
          :currentLevel,
          :solvedPuzzles,
          :averageTime,
        ) = state;

        return Scaffold(
          appBar: AppBar(
            actions: [
              NavigationButton(
                onPressed: () async {
                  await ref
                      .read(routerProvider)
                      .push<bool>(SettingsPage.routePath);

                  await controller.refresh();
                },

                tooltip: 'settings.title'.tr(),
                child: const Icon(LucideIcons.settings),
              ),
            ],

            title: Text(
              'home.greeting'.tr(namedArgs: {'name': player.name}),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              await controller.refresh();
            },

            child: LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxWidth;
                final remaining = width - Breakpoints.small;

                return SafeArea(
                  minimum: EdgeInsets.symmetric(
                    horizontal: remaining <= 16.0 ? 16.0 : remaining / 2,
                    vertical: 12.0,
                  ),

                  child: FillScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 8.0,

                          children: [
                            _buildHero(
                              currentLevel: currentLevel,
                              solvedPuzzles: solvedPuzzles,
                            ),

                            const Separator(verticalIndent: 8.0),

                            Row(
                              spacing: 12.0,
                              children: [
                                _buildButton(
                                  label: 'levels.title'.tr(),
                                  icon: LucideIcons.grip,
                                  route: '/levels',

                                  controller: controller,
                                  highlight: false,
                                ).expand(),
                                _buildButton(
                                  label: 'home.buttons.play'.tr(),
                                  icon: LucideIcons.play,
                                  route: '/levels/${currentLevel.id}',

                                  controller: controller,
                                  highlight: true,
                                ).expand(),
                              ],
                            ),
                          ],
                        ).expand(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 12.0,

                          children: [
                            _buildMetric(
                              icon: Symbols.timer,
                              label: 'home.metrics.avg_time'.tr(),
                              value: formatDuration(averageTime),
                              highlight: false,
                            ),

                            _buildMetric(
                              icon: Symbols.local_fire_department,
                              label: 'home.metrics.streak'.tr(),
                              value: 'home.metrics.days'.tr(
                                namedArgs: {'count': '${player.streakDays}'},
                              ),
                              highlight: true,
                            ),
                          ].map((e) => e.expand()).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget card({
    required Widget child,
    double radius = 12.0,
    double insets = 12.0,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(insets),

      child: child,
    );
  }

  Widget _buildHero({required Level currentLevel, required int solvedPuzzles}) {
    final theme = Theme.of(context);

    return card(
      insets: 20.0,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 4.0,

        children: [
          Row(
            spacing: 8.0,
            children: [
              Icon(
                TablerIcons.circle_filled,
                size: 12.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                (currentLevel.id == 1
                        ? 'home.status.inactive'
                        : 'home.status.active')
                    .tr(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ).padded(const EdgeInsets.only(bottom: 12.0)),

          Text(
            (currentLevel.id == 1
                    ? 'home.journey.start'
                    : 'home.journey.continue')
                .tr(),
            textAlign: TextAlign.start,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            'levels.label'.tr(namedArgs: {'id': '${currentLevel.id}'}),
            textAlign: TextAlign.start,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),

          const Separator(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('home.progress.title'.tr()),
              Text(
                'home.progress.puzzles_solved'.tr(
                  namedArgs: {'count': '$solvedPuzzles'},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required String route,
    MainController? controller,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);

    return FilledButton.icon(
      onPressed: () async {
        Debugger.log('Navigating to $route');

        await ref.read(routerProvider).push(route);

        Debugger.log('Returned from $route, refreshing main data...');

        await controller?.refresh();
      },

      style: Theme.of(context).iconButtonTheme.style?.copyWith(
        backgroundColor: WidgetStateProperty.all(
          highlight
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.75),
        ),
      ),

      label: Text(label),
      icon: Icon(icon),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);

    return card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.0,

        children: [
          Icon(
            icon,
            color: theme.colorScheme.outline,
          ).padded(const EdgeInsets.only(bottom: 4.0)),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: highlight
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }
}
