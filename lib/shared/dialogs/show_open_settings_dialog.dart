import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'show_app_dialog.dart';

Future<void> showOpenSettingsDialog(BuildContext context) {
  return showAppDialog(
    context,
    title: 'modals.notifications.title'.tr(),
    description: 'modals.notifications.message'.tr(),

    primaryButtonText: 'actions.system.open_settings'.tr(),
    secondaryButtonText: 'actions.common.cancel'.tr(),
  );
}
