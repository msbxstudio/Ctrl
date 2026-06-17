import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/features/player/index.dart';
import 'package:ctrl/shared/dialogs/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final legalOptions = const <Map<String, dynamic>>[
    {
      'id': 1,
      'label': 'settings.privacy.privacy_policy',
      'url': 'https://ctrl.msbx.dev/privacy',
    },
    {
      'id': 2,
      'label': 'settings.privacy.terms_of_service',
      'url': 'https://ctrl.msbx.dev/terms',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(settingsControllerProvider.notifier);
    final asyncValue = ref.watch(settingsControllerProvider);

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
        child: RefreshIndicator.adaptive(
          onRefresh: controller.refresh,

          child: asyncValue.when(
            data: (data) {
              final SettingsData(:player) = data;

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),

                children: [
                  ...[
                    Text('settings.sections.account'.tr()),
                    card(
                      child: option(
                        title: 'settings.account.change_username'.tr(),
                        onTap: () async {
                          final name = await showChangeUsernameModal(
                            context,
                            initialValue: player.name,
                          );

                          if (name == null) return;

                          await controller.updateName(name: name);
                        },

                        trailing: trailing(
                          text: player.name,
                          icon: LucideIcons.chevronRight,
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),

                  const SizedBox(height: 28.0),

                  ...[
                    Text('settings.sections.preferences'.tr()),
                    card(
                      child: option(
                        title: 'settings.preferences.language'.tr(),
                        onTap: () async {
                          final lang = await showChoiceLanguageModal(
                            context,
                            initialValue: context.locale.languageCode,
                          );

                          if (lang == null) return;

                          await controller.updateLanguage(
                            context,
                            languageCode: lang,
                          );
                        },

                        trailing: trailing(
                          text: context.locale.languageCode.toUpperCase(),
                          icon: LucideIcons.chevronRight,
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),

                  const SizedBox(height: 24.0),

                  ...[
                    Text('settings.sections.privacy'.tr()),
                    card(
                      child: Column(
                        children: legalOptions
                            .map(
                              (e) => option(
                                title: (e['label'] as String).tr(),
                                onTap: () async {
                                  try {
                                    final success = await launchUrl(
                                      Uri.parse(e['url']),
                                      mode: LaunchMode.externalApplication,
                                    );

                                    if (!success) {
                                      throw const LaunchException(
                                        'No se pudo abrir el enlace solicitado.',
                                      );
                                    }
                                  } on LaunchException catch (e) {
                                    showSnackbar(context, e.message);
                                  }
                                },

                                borderRadius: e['id'] == 1
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      )
                                    : BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                trailing: trailing(
                                  icon: LucideIcons.arrowUpRight,
                                ),
                              ),
                            )
                            .divide(const Separator(verticalIndent: 4.0)),
                      ),
                    ),
                  ].divide(const SizedBox(height: 8.0)),

                  const SizedBox(height: 24.0),

                  ...[
                    Text('settings.sections.donations'.tr()),
                    card(
                      child: Column(
                        children: [
                          option(
                            title: 'settings.donations.coffee'.tr(),
                            onTap: () {},

                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                            leading: const Text('☕'),
                            trailing: const Text('\$0.99'),
                          ),
                          option(
                            title: 'settings.donations.pizza'.tr(),
                            onTap: () {},

                            borderRadius: BorderRadius.zero,
                            leading: const Text('🍕'),
                            trailing: const Text('\$4.99'),
                          ),
                          option(
                            title: 'settings.donations.support'.tr(),
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

                  const Separator(verticalIndent: 24.0),

                  ...[
                    Text('settings.sections.danger_zone'.tr()),
                    FilledButton.tonal(
                      onPressed: () async {
                        final confirmed = await showConfirmationModal(
                          context,
                          title: 'settings.danger_zone.erase_confirm'.tr(),
                        );

                        if (confirmed != true) return;
                        try {
                          await DatabaseService.instance.reset();

                          showSnackbar(
                            context,
                            'settings.danger_zone.erase_success'.tr(),
                            behavior: SnackBarBehavior.fixed,
                          );
                        } catch (e) {
                          showSnackbar(
                            context,
                            'settings.danger_zone.erase_error'.tr(),
                            behavior: SnackBarBehavior.fixed,
                          );
                        }
                      },

                      style: Theme.of(context).filledButtonTheme.style
                          ?.copyWith(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),

                      child: Text('settings.danger_zone.erase_all'.tr()),
                    ),
                  ].divide(const SizedBox(height: 8.0)),
                ],
              );
            },

            error: (_, _) {
              return Text('settings.error'.tr()).centered();
            },

            loading: () {
              return const CircularProgressIndicator.adaptive().centered();
            },
          ),
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

  Widget trailing({String? text, IconData? icon}) {
    Debugger.ensure(
      text != null || icon != null,
      'Either text or icon must be provided',
    );

    return Row(
      spacing: 4.0,
      children: [
        if (text != null)
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        if (icon != null)
          Icon(icon, size: 20.0, color: Theme.of(context).colorScheme.outline),
      ],
    );
  }
}
