import 'package:ctrl/core/extensions/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class MainPageLoader extends ConsumerWidget {
  const MainPageLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef _) {
    return const CircularProgressIndicator.adaptive().centered();
  }
}
