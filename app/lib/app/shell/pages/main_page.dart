import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:msbx/config.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/utils.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/app/shell.dart';
import 'package:ctrl/features/level.dart';
import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

import 'main_page_error.dart';
import 'main_page_skeleton.dart';

final class MainPage extends ConsumerStatefulWidget {
  ///
  const new({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainPageState();
  }
}

final class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controller = ref.read(mainControllerProvider.notifier);
    final asyncValue = ref.watch(mainControllerProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),

      child: asyncValue.when(
        loading: () {
          return const MainPageSkeleton();
        },

        error: (e, _) {
          return MainPageError(
            onRetry: () async {
              await controller.refresh();
            },
            error: e,
          );
        },

        data: (data) {
          final (:player, :currentLevel, :solvedPuzzles, :averageTime) = data;

          return Scaffold(
            appBar: AppBar(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              actions: [
                IconButton(
                  onPressed: () async {
                    await ref.read(routerProvider).push(SettingsPage.routePath);
                    await controller.refresh();
                  },

                  tooltip: 'home.settings_tooltip'.tr(),
                  icon: Icon(
                    LucideIcons.settings,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],

              bottom: PreferredSize(
                preferredSize: Size.fromHeight(24.0),
                child: greeting(player.name),
              ),
            ),

            body: SafeArea(
              child: RefreshIndicator.adaptive(
                onRefresh: controller.refresh,

                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final width = constraints.maxWidth;
                    final remaining = width - Breakpoints.small;

                    return ScrollableFilledView(
                      padding: EdgeInsets.symmetric(
                        horizontal: remaining <= 16.0 ? 16.0 : remaining / 2,
                        vertical: 12.0,
                      ),

                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 8.0,

                            children: [
                              hero(
                                currentLevel: currentLevel,
                                solvedPuzzles: solvedPuzzles,
                              ),

                              const Separator(verticalIndent: 8.0),

                              Row(
                                spacing: 12.0,
                                children: [
                                  button(
                                    label: 'home.buttons.levels'.tr(),
                                    icon: LucideIcons.grip,
                                    route: '/levels',

                                    controller: controller,
                                    highlight: false,
                                  ).expand(),
                                  button(
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
                              metric(
                                icon: Symbols.timer,
                                label: 'home.metrics.avg_time'.tr(),
                                value: formatDuration(averageTime),
                                highlight: false,
                              ).expand(),
                              metric(
                                icon: Symbols.local_fire_department,
                                label: 'home.metrics.streak'.tr(),
                                value: 'home.metrics.days'.tr(
                                  namedArgs: {'count': '${player.streakDays}'},
                                ),
                                highlight: true,
                              ).expand(),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget greeting(String name) {
    return Text(
          'home.greeting'.tr(namedArgs: {'name': name}),
          style: Theme.of(context).textTheme.titleLarge,
        )
        .padded(const EdgeInsets.symmetric(horizontal: 16.0))
        .aligned(Alignment.centerLeft)
        .constrained(maxWidth: Breakpoints.small)
        .centered();
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

  Widget hero({required Level currentLevel, required int solvedPuzzles}) {
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
            'home.level'.tr(namedArgs: {'id': '${currentLevel.id}'}),
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

  Widget button({
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
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),

      label: Text(label),
      icon: Icon(icon),
    );
  }

  Widget metric({
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
