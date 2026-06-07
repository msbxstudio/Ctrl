import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
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
    return MainPageState();
  }
}

final class MainPageState extends ConsumerState<MainPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(goRouterProvider).push(SettingsPage.routePath);
            },

            tooltip: 'Settings',
            icon: Icon(LucideIcons.settings, color: theme.colorScheme.outline),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24.0),
          child: _greeting(
            'User',
          ).padded(const EdgeInsets.symmetric(horizontal: 16.0)),
        ),
      ),

      body: Column(
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
          _hero(),

          const Separator(verticalIndent: 8.0),

          Row(
            spacing: 12.0,
            children:
                const <Map<String, dynamic>>[
                      {
                        'label': 'Levels',
                        'icon': LucideIcons.grip,
                        'route': '/levels',
                        'highlight': false,
                      },
                      {
                        'label': 'Play',
                        'icon': LucideIcons.play,
                        'route': '/levels/1',
                        'highlight': true,
                      },
                    ]
                    .map(
                      (it) => FilledButton.icon(
                        onPressed: () async {
                          await ref.read(goRouterProvider).push(it['route']);
                        },

                        style: Theme.of(context).iconButtonTheme.style
                            ?.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                it['highlight']
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outlineVariant
                                          .withValues(alpha: 0.75),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),

                        label: Text(it['label']),
                        icon: Icon(it['icon']),
                      ).expand(),
                    )
                    .toList(),
          ),
        ],
      ).padded(const EdgeInsets.symmetric(horizontal: 16.0)),

      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 12.0,

          children:
              const <Map<String, dynamic>>[
                    {
                      'icon': Symbols.timer,
                      'label': 'AVG TIME',
                      'value': '02:10',
                      'highlight': false,
                    },
                    {
                      'icon': Symbols.local_fire_department,
                      'label': 'STREAK',
                      'value': '12 DAYS',
                      'highlight': true,
                    },
                  ]
                  .map(
                    (it) => _metric(
                      icon: it['icon'],
                      label: it['label'],
                      value: it['value'],
                      highlight: it['highlight'],
                    ).expand(),
                  )
                  .toList(),
        ).padded(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
      ),
    );
  }

  Widget _greeting(String name) {
    return Text('Hello, $name!', style: Theme.of(context).textTheme.titleMedium)
        .aligned(Alignment.centerLeft)
        .padded(const EdgeInsets.symmetric(horizontal: 8.0));
  }

  Widget _card({
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

  Widget _hero() {
    final theme = Theme.of(context);

    return _card(
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
                'SESSION ACTIVE',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ).padded(const EdgeInsets.only(bottom: 12.0)),

          Text(
            'CONTINUE JOURNEY',
            textAlign: TextAlign.start,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            'Level 42',
            textAlign: TextAlign.start,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),

          const Separator(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [Text('Progress'), Text('84 PUZZLES SOLVED')],
          ),
        ],
      ),
    );
  }

  Widget _metric({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);

    return _card(
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
