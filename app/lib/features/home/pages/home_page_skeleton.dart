import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:msbx/extensions.dart';

final class HomePageSkeleton extends ConsumerWidget {
  /// ...
  const new({super.key});

  @override
  Widget build(BuildContext _, WidgetRef _) {
    return Scaffold(
      body: CircularProgressIndicator.adaptive().centered(),
    );
  }
}
