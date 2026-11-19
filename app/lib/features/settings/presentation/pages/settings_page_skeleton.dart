import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msbx/msbx.dart';

final class SettingsPageSkeleton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return const CircularProgressIndicator.adaptive().centered();
  }
}
