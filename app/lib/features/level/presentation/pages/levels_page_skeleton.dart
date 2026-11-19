import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/core/extensions/index.dart';

final class LevelsPageSkeleton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return const CircularProgressIndicator.adaptive().centered();
  }
}
