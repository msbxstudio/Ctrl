import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/helpers.dart';

import 'package:ctrl/core/services.dart';

Future<void> resetApp(BuildContext context) async {
  late final String message;

  try {
    await DatabaseService.instance.reset();

    message = 'settings.reset.success'.tr();
  } catch (_) {
    message = 'errors.reset'.tr();
  }

  if (!context.mounted) return;

  showSnackbar(context, message);
}
