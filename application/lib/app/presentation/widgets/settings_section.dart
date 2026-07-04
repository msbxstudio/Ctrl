import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'section_card.dart';

final class SettingsSection extends ConsumerWidget {
  final List<SettingsAction> actions;
  final String title;

  const SettingsSection({
    super.key,
    required this.actions,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        Text(title),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 22.0),
          child: SectionCard(
            child: Column(
              children: actions.divide(const Separator(verticalIndent: 0.0)),
            ),
          ),
        ),
      ],
    );
  }
}
