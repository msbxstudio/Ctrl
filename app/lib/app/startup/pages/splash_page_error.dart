import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';

import 'package:ctrl/features/settings.dart';

final class SplashPageError extends ConsumerWidget {
  const new({super.key, required this.onRetry, required this.error});

  ///
  final Future<void> Function() onRetry;

  ///
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef _) {
    final theme = Theme.of(context);

    final size = scaledSize(context, scale: 0.325);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12.0,

          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/icon-white.svg',
                width: size,
                height: size,
              ),
            ).expand(),

            Text(
              'errors.startup.title'.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),

            Text(
              'errors.startup.message'.tr(),
              textAlign: TextAlign.center,

              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ).padded(const EdgeInsets.only(bottom: 16.0)),

            FilledButton(
              onPressed: () async {
                final confirm = await showResetAppDialog(context);

                if (confirm != true) return;

                await resetApp(context);
              },

              child: Text('settings.reset.app'.tr()),
            ),

            ElevatedButton(
              onPressed: () async {
                await ServicesBinding.instance.exitApplication(
                  AppExitType.required,
                );
              },

              style: theme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  theme.colorScheme.outlineVariant.withValues(alpha: 0.75),
                ),
              ),

              child: Text('common.actions.exit'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
