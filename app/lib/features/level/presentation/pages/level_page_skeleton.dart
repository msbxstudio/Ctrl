import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays the loading state of the level page.
///
/// Presents a centered, indeterminate progress indicator while level data
/// is being loaded.
final class LevelPageSkeleton extends ConsumerWidget {
  /// Creates the loading placeholder for the level page.
  const new({super.key});

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
