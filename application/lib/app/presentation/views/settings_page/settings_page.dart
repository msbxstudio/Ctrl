import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/features/player/index.dart';
import 'package:ctrl/shared/dialogs/index.dart';
import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'settings_page_error.dart';
import 'settings_page_loader.dart';

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
  static const routePath = '/settings';

  const SettingsPage({super.key});

  @override
  ConsumerState createState() {
    return _SettingsPageState();
  }
}

final class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(settingsControllerProvider.notifier);
    final asyncValue = ref.watch(settingsControllerProvider);

    return asyncValue.when(
      data: (data) {
        final SettingsData(:player, :langCode, :soundEffects) = data;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,

            titleSpacing: 8.0,
            title: Text('settings.title'.tr()),

            leadingWidth: 60.0,
            leading: const PopButton(),
          ),
          body: SafeArea(
            child: RefreshIndicator.adaptive(
              onRefresh: controller.refresh,

              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),

                children: [
                  SettingsSection(
                    title: 'settings.sections.account'.tr(),
                    actions: [
                      SettingsAction.tile(
                        onPressed: () {
                          handleChangeName(controller, player);
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
                      SettingsAction.tile(
                        onPressed: () {
                          handleChangeLang(controller);
                        },

                        title: 'settings.preferences.language'.tr(),
                        trailing: Text(langCode),
                      ),
                      SettingsAction.toggle(
                        onChanged: (value) async {
                          await controller.updateSound(sound: value);
                        },

                        title: 'settings.preferences.sound_effects'.tr(),
                        value: soundEffects,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24.0),

                  SettingsSection(
                    title: 'settings.sections.privacy'.tr(),
                    actions: _legalOptions
                        .map(
                          (e) => SettingsAction.link(
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
                          (e) => SettingsAction.tile(
                            onPressed: () async {
                              try {
                                await PurchaseService.instance.purchase(e.code);
                              } catch (_) {
                                showSnackbar(
                                  context,
                                  'snackbar.purchase_failed'.tr(),
                                  behavior: SnackBarBehavior.fixed,
                                );
                              }
                            },

                            leading: SvgPicture.asset(
                              e.picture,
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Text('\$${e.price.toStringAsFixed(2)}'),

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
                      onPressed: handleEraseData,

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
              ),
            ),
          ),
        );
      },

      error: (_, _) {
        return SettingsPageError(
          onRetry: () {
            return controller.refresh();
          },
        );
      },

      loading: () {
        return const SettingsPageLoader();
      },
    );
  }

  void handleChangeName(SettingsController controller, Player player) async {
    final name = await showChangeUsernameModal(
      context,
      initialValue: player.name,
    );

    if (name == null) return;
    await controller.updateName(name: name);
  }

  void handleChangeLang(SettingsController controller) async {
    final lang = await showChoiceLanguageModal(
      context,
      initialValue: context.locale.languageCode,
    );

    if (lang == null) return;
    await controller.updateLanguage(context, languageCode: lang);
  }

  void handleEraseData() async {
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
  }
}
