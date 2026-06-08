import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/features/level/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:material_symbols_icons/symbols.dart';

final class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() {
    return _MainPageState();
  }
}

final class _MainPageState extends ConsumerState<MainPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final _ = ref.read(mainControllerProvider.notifier);
    final asyncValue = ref.watch(mainControllerProvider);

    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        actions: asyncValue.hasValue
            ? [
                IconButton(
                  onPressed: () async {
                    await ref
                        .read(goRouterProvider)
                        .push(SettingsPage.routePath);
                  },

                  tooltip: 'Settings',
                  icon: Icon(
                    LucideIcons.settings,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ]
            : [],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24.0),
          child: asyncValue.hasValue
              ? Builder(
                  builder: (_) {
                    final MainData(:player) = asyncValue.value!;

                    return greeting(
                      player.name,
                    ).padded(const EdgeInsets.symmetric(horizontal: 16.0));
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),

      body: asyncValue.when(
        data: (data) {
          final MainData(:player, :currentLevel, :averageTime) = data;

          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8.0,

            children: [
              Text(
                'CTRL by MSBX',
                textAlign: TextAlign.end,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
                ),
              ),
              hero(currentLevel: currentLevel),

              const Separator(verticalIndent: 8.0),

              Row(
                spacing: 12.0,
                children: [
                  button(
                    label: 'Levels',
                    icon: LucideIcons.grip,
                    route: '/levels',
                    highlight: false,
                  ).expand(),
                  button(
                    label: 'Play',
                    icon: LucideIcons.play,
                    route: '/levels/${currentLevel.id}',
                    highlight: true,
                  ).expand(),
                ],
              ),
            ],
          ).padded(const EdgeInsets.symmetric(horizontal: 16.0));
        },
        error: (_, _) {
          return const Text('An error occurred').centered();
        },
        loading: () {
          return const CircularProgressIndicator.adaptive().centered();
        },
      ),

      bottomNavigationBar: asyncValue.hasValue
          ? Builder(
              builder: (_) {
                final MainData(:player) = asyncValue.value!;

                return SafeArea(
                  child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 12.0,

                        children: [
                          metric(
                            icon: Symbols.timer,
                            label: 'AVG TIME',
                            value: '00:00',
                            highlight: false,
                          ).expand(),
                          metric(
                            icon: Symbols.timer,
                            label: 'STREAK',
                            value: '${player.streakDays} DAYS',
                            highlight: true,
                          ).expand(),
                        ],
                      ).padded(
                        const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                      ),
                );
              },
            )
          : null,
    );
  }

  Widget greeting(String name) {
    return Text('Hello, $name!', style: Theme.of(context).textTheme.titleMedium)
        .aligned(Alignment.centerLeft)
        .padded(const EdgeInsets.symmetric(horizontal: 8.0));
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

  Widget hero({required Level currentLevel}) {
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
                '${currentLevel.id == 1 ? 'NO' : ''} SESSION ACTIVE',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ).padded(const EdgeInsets.only(bottom: 12.0)),

          Text(
            '${currentLevel.id == 1 ? 'START' : 'CONTINUE'} JOURNEY',
            textAlign: TextAlign.start,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            'Level ${currentLevel.id}',
            textAlign: TextAlign.start,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),

          const Separator(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Progress'),
              Text('${currentLevel.id - 1} PUZZLES SOLVED'),
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
    bool highlight = false,
  }) {
    final theme = Theme.of(context);

    return FilledButton.icon(
      onPressed: () async {
        await ref.read(goRouterProvider).push(route);
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
}
