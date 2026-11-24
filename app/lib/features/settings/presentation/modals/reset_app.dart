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
        title: 'settings.danger_zone.erase_confirm'.tr(),

        actions: [
          PromptDialogAction<bool>(
            value: true,
            label: 'Confirmar',
            isDestructive: true,
          ),
          PromptDialogAction<bool>(
            value: false,
            label: 'Cancelar',
            isDestructive: false,
          ),
        ],
      );
    },
  );
}
