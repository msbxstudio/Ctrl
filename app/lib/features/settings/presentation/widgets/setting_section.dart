import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:msbx/extensions.dart';

import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

import 'section_card.dart';

final class SettingsSection extends ConsumerWidget {
  final List<SettingOption> actions;
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
