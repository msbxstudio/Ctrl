import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/helpers.dart';
import 'package:msbx/widgets.dart';

Future<bool?> showResetAppDialog(BuildContext context) {
  return showModalDialog(
    context,
    builder: (_) {
      return PromptDialog<bool>.adaptive(
        title: 'settings.reset.confirm.title'.tr(),
        message: 'settings.reset.confirm.message'.tr(),

        actions: [
          PromptDialogAction<bool>(
            value: true,
            label: 'common.actions.confirm'.tr(),
            isDestructive: true,
          ),
          PromptDialogAction<bool>(
            value: false,
            label: 'common.actions.cancel'.tr(),
            isDestructive: false,
          ),
        ],
      );
    },
  );
}
