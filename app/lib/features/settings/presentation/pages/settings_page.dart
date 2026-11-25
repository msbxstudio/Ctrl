import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/config.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';

import 'package:ctrl/core/services.dart';
import 'package:ctrl/core/utils.dart';
import 'package:ctrl/features/player.dart';
import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

import 'settings_page_error.dart';
import 'settings_page_skeleton.dart';

final _legalOptions = const <({String key, String source})>[
  (
    key: 'settings.privacy.privacy_policy',
    source: 'https://ctrl.msbx.dev/privacy',
  ),
  (
    key: 'settings.privacy.terms_of_service',
    source: 'https://ctrl.msbx.dev/terms',
  ),
];

final _donationOptions =
    const <({String key, String picture, String code, double price})>[
      (
        key: 'settings.donations.coffee',
        picture: 'assets/images/coffee.svg',
        code: 'ctrl_coffee_donation',
        price: 0.99,
      ),
      (
        key: 'settings.donations.pizza',
        picture: 'assets/images/pizza.svg',
        code: 'ctrl_pizza_donation',
        price: 4.99,
      ),
      (
        key: 'settings.donations.support',
        picture: 'assets/images/heart.svg',
        code: 'ctrl_support_donation',
        price: 9.99,
      ),
    ];

final class SettingsPage extends ConsumerStatefulWidget {
  const new({super.key});

  static const routePath = '/settings';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SettingsPageState();
  }
}

final class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext _) {
    final controller = ref.read(settingsControllerProvider.notifier);
    final value = ref.watch(settingsControllerProvider);

    return value.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,

      loading: () {
        return const SettingsPageSkeleton();
      },

      error: (err, _) {
        return SettingsPageError(
          onRetry: () async {
            await controller.refresh();
          },
          error: err,
        );
      },

      data: (state) {
        final SettingsState(:player, :language, :allowSoundEffects) = state;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,

            title: Text('settings.title'.tr()),
            leading: const NavigationButton.back(),
          ),

          body: SafeArea(
            child: RefreshIndicator.adaptive(
              onRefresh: () async {
                await controller.refresh();
              },

              child: LayoutBuilder(
                builder: (_, constraints) {
                  final width = constraints.maxWidth;
                  final remaining = width - Breakpoints.small;

                  return ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: remaining <= 16.0 ? 16.0 : remaining / 2,
                      vertical: 12.0,
                    ),

                    children: [
                      SettingsSection(
                        title: 'settings.sections.account'.tr(),
                        actions: [
                          SettingOption.tile(
                            onPressed: () async {
                              final name = await showChangeNameSheet(
                                context,
                                initialValue: player.name,
                              );

                              if (name == null || name == player.name) return;

                              try {
                                await controller.updatePlayerName(name: name);
                                await controller.refresh();
                              } catch (error) {
                                if (!context.mounted) return;
                                showSnackbar(
                                  context,
                                  errorMessage(
                                    error,
                                    fallbackKey: 'errors.player.save',
                                  ),
                                );
                              }
                            },

                            title: 'settings.account.change_username'.tr(),
                            trailing: Text(player.name),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28.0),

                      SettingsSection(
                        title: 'settings.sections.preferences'.tr(),
                        actions: [
                          SettingOption.tile(
                            onPressed: () async {
                              final lang = await showPickLanguageSheet(
                                context,
                                initialValue: language,
                              );

                              if (lang == null) return;

                              try {
                                await ref
                                    .read(preferencesNotifierProvider.notifier)
                                    .setLanguage(lang);
                              } catch (error) {
                                if (!context.mounted) return;
                                showSnackbar(
                                  context,
                                  errorMessage(
                                    error,
                                    fallbackKey: 'errors.settings.save',
                                  ),
                                );
                              }
                            },

                            title: 'settings.preferences.language'.tr(),
                            trailing: Text(
                              language.labelKey.tr(),
                            ),
                          ),
                          SettingOption.toggle(
                            onChanged: (value) async {
                              try {
                                await controller.updateAllowSoundEffects(
                                  allow: value,
                                );
                              } catch (error) {
                                if (!context.mounted) return;
                                showSnackbar(
                                  context,
                                  errorMessage(
                                    error,
                                    fallbackKey: 'errors.settings.save',
                                  ),
                                );
                              }
                            },

                            title: 'settings.preferences.sound_effects'.tr(),
                            value: allowSoundEffects,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24.0),

                      SettingsSection(
                        title: 'settings.sections.privacy'.tr(),
                        actions: _legalOptions
                            .map(
                              (e) => SettingOption.link(
                                uri: Uri.parse(e.source),
                                title: e.key.tr(),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 24.0),

                      SettingsSection(
                        title: 'settings.sections.donations'.tr(),
                        actions: _donationOptions
                            .map(
                              (e) => SettingOption.tile(
                                onPressed: () async {
                                  try {
                                    await PurchaseService.instance.purchase(
                                      e.code,
                                    );
                                  } catch (error) {
                                    if (!context.mounted) return;
                                    showSnackbar(
                                      context,
                                      errorMessage(
                                        error,
                                        fallbackKey: 'errors.purchase.start',
                                      ),
                                      behavior: SnackBarBehavior.fixed,
                                    );
                                  }
                                },

                                leading: SvgPicture.asset(
                                  e.picture,
                                  width: 20.0,
                                  height: 20.0,
                                ),
                                trailing: Text(
                                  '\$${e.price.toStringAsFixed(2)}',
                                ),

                                title: e.key.tr(),
                                showIcon: false,
                              ),
                            )
                            .toList(),
                      ),

                      const Separator(verticalIndent: 24.0),

                      ...[
                        Text('settings.sections.danger_zone'.tr()),
                        FilledButton.tonal(
                          onPressed: () async {
                            final confirm = await showResetAppDialog(context);

                            if (confirm != true) return;

                            await resetApp(context);
                            await controller.refresh();
                          },

                          child: Text('settings.reset.action'.tr()),
                        ),
                      ].divide(const SizedBox(height: 8.0)),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
