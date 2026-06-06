import 'package:ctrl/app/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class LevelsPage extends ConsumerStatefulWidget {
  static const routePath = '/levels';

  const LevelsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return LevelsPageState();
  }
}

final class LevelsPageState extends ConsumerState<LevelsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _items = List<int>.generate(127, (index) => index + 1);

  final _currentLevel = 27;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: const Text('Levels Page'),

        leadingWidth: 48.0,
        leading: const PopButton(),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 1.0,
        ),

        itemCount: _items.length,
        itemBuilder: (_, index) {
          return IconButton(
            onPressed: index + 1 <= _currentLevel
                ? () async {
                    await ref
                        .read(goRouterProvider)
                        .push('/levels/${index + 1}');
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
      ),
    );
  }
}
