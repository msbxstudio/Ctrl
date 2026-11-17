import 'package:ctrl/core/extensions/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SettingsPageError extends ConsumerWidget {
  final Future<void> Function() onRetry;

  const SettingsPageError({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context, WidgetRef _) {
    return Text('settings.error'.tr()).centered();
  }
}
