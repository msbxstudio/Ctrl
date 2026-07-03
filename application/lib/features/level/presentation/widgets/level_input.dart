import 'package:ctrl/core/extensions/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

final class LevelInput extends ConsumerWidget {
  final void Function() onSubmit;

  final void Function(String) onAdd;

  final void Function() onClear;

  final TextEditingController controller;

  final List<String> items;

  const LevelInput({
    super.key,
    required this.onSubmit,
    required this.onClear,
    required this.onAdd,
    required this.controller,
    required this.items,
  }) : assert(items.length == 10, 'Items list must have 10 items');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        filledButtonTheme: FilledButtonThemeData(
          style: theme.filledButtonTheme.style?.copyWith(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
        ),
      ),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 4.0,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,

              children: [
                TextFormField(
                  readOnly: true,
                  controller: controller,

                  decoration: InputDecoration(
                    hintText: 'levels.answer_placeholder'.tr(),
                    suffixIcon: IconButton(
                      onPressed: onClear,

                      style: theme.iconButtonTheme.style?.copyWith(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),

                        foregroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.pressed)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      icon: const Icon(LucideIcons.x),
                    ),
                  ),
                ).expand(flex: 31),

                FilledButton.tonal(
                  onPressed: onSubmit,

                  child: Text('levels.enter'.tr()),
                ).expand(flex: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,

              children: items
                  .take(5)
                  .map(
                    (e) => FilledButton.tonal(
                      onPressed: () => onAdd.call(e),

                      child: Text(e, textAlign: TextAlign.center),
                    ).expand(),
                  )
                  .toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,

              children: items
                  .skip(5)
                  .map(
                    (e) => FilledButton.tonal(
                      onPressed: () => onAdd.call(e),

                      child: Text(e, textAlign: TextAlign.center),
                    ).expand(),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    ).padded(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0));
  }
}
