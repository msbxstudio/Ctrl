import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/shared/dialogs/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons/lucide_icons.dart';

final class SettingsPage extends ConsumerStatefulWidget {
  static const routePath = '/settings';

  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SettingsPageState();
  }
}

final class _SettingsPageState extends ConsumerState<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: Text('settings.title'.tr()),

        leadingWidth: 48.0,
        leading: const PopButton(),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

          children: [
            ...[
              Text('settings.sections.account'.tr()),
              card(
                child: option(title: 'Change username', onTap: () {}),
              ),
            ].divide(const SizedBox(height: 8.0)),

            const SizedBox(height: 28.0),

            ...[
              Text('settings.sections.preferences'.tr()),
              card(
                child: option(
                  title: 'Language',
                  onTap: () {},

                  trailing: Row(
                    spacing: 4.0,
                    children: [
                      Text(
                        'EN',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ].divide(const SizedBox(height: 8.0)),

            const SizedBox(height: 24.0),
            ...[
              Text('settings.sections.advanced'.tr()),
              FilledButton.tonal(
                onPressed: () async {
                  final confirmed = await showConfirmationModal(
                    context,
                    title:
                        'Are you sure you want to erase all data? This action cannot be undone.',
                  );

                  if (confirmed != true) return;
                  try {
                    await DatabaseService.instance.reset();

                    showSnackbar(
                      context,
                      'All data has been erased successfully.',
                      behavior: SnackBarBehavior.fixed,
                    );
                  } catch (e) {
                    showSnackbar(
                      context,
                      'An error occurred while erasing data.'
                      '\n'
                      'Please try again later.',
                      behavior: SnackBarBehavior.fixed,
                    );
                  }
                },

                child: const Text('Erase all data'),
              ),
            ].divide(const SizedBox(height: 8.0)),

            const Separator(verticalIndent: 24.0),

            ...[
              Text('settings.sections.donations'.tr()),
              card(
                child: Column(
                  children: [
                    option(
                      title: 'Buy Me a Coffee',
                      onTap: () {},

                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      leading: const Text('☕'),
                      trailing: const Text('\$0.99'),
                    ),
                    option(
                      title: 'Buy Me a Pizza',
                      onTap: () {},

                      borderRadius: BorderRadius.zero,
                      leading: const Text('🍕'),
                      trailing: const Text('\$4.99'),
                    ),
                    option(
                      title: 'Support Me',
                      onTap: () {},

                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      leading: const Text('❤️'),
                      trailing: const Text('\$9.99'),
                    ),
                  ].divide(const Separator(verticalIndent: 4.0)),
                ),
              ),
            ].divide(const SizedBox(height: 8.0)),
          ],
        ),
      ),
    );
  }

  Widget card({
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: borderColor ?? Theme.of(context).colorScheme.outline,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(borderRadius: BorderRadius.circular(8.0), child: child),
    );
  }

  Widget option({
    required String title,
    required VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Widget? leading,
    Widget? trailing,
    bool centerTitle = false,
  }) {
    return Material(
      borderRadius: borderRadius ?? BorderRadius.circular(8.0),

      child: InkWell(
        onTap: onTap,

        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 8.0,

              children: [
                ?leading,
                Text(
                  title,
                  textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                ).expand(),
                ?trailing,
              ],
            ).padded(
              padding ??
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
      ),
    );
  }
}
