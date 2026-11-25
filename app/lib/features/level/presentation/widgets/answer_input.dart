import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:msbx/extensions.dart';
import 'package:msbx/msbx.dart';

/// Provides a custom input interface for constructing and submitting
/// answers within a level.
final class AnswerInput extends ConsumerWidget {
  /// Creates a level input with the specified input options, callbacks,
  /// and answer controller.
  ///
  /// The [items] list must contain exactly ten input tokens.
  const new({
    super.key,
    required this.onSubmit,
    required this.onClear,
    required this.onAdd,
    required this.items,
    required this.controller,
  }) : assert(items.length == 10, 'Items list must have 10 items');

  /// Called when the player requests to submit the current answer.
  final void Function() onSubmit;

  /// Called with the selected input token when the player adds it
  /// to the current answer.
  final void Function(String) onAdd;

  /// Called when the player requests to clear the current answer.
  final void Function() onClear;

  /// The ten input tokens available for constructing an answer.
  ///
  /// Their order determines their position within the keyboard layout.
  final List<String> items;

  /// The controller used to manage the player's current answer.
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        filledButtonTheme: FilledButtonThemeData(
          style: theme.filledButtonTheme.style?.copyWith(
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),

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
          GridView.builder(
            shrinkWrap: true,
            primary: false,

            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 4.0,
              mainAxisExtent: 48.0,
            ),

            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              return FilledButton.tonal(
                onPressed: () {
                  onAdd.call(item);
                },

                child: Text(
                  item,
                ).centered(),
              );
            },
          ),
        ],
      ),
    );
  }
}
