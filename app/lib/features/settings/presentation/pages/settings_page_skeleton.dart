import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:msbx/extensions.dart';

/// Displays the loading state of the settings page.
///
/// Presents a centered, platform-adaptive progress indicator within
/// a scaffold.
final class SettingsPageSkeleton extends ConsumerWidget {
  /// Creates the loading placeholder for the settings page.
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return Scaffold(body: CircularProgressIndicator.adaptive().centered());
  }
}
