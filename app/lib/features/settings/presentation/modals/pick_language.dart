import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:msbx/extensions.dart';

import 'package:msbx/helpers.dart';
import 'package:msbx/widgets.dart';

import 'package:ctrl/features/settings.dart';

Future<AppLanguage?> showPickLanguageSheet(
  BuildContext context, {
  required AppLanguage initialValue,
}) {
  return showModalSheet(
    context,
    builder: (_) {
      var currentValue = initialValue;

      return Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),

        child: SafeArea(
          minimum: const EdgeInsets.all(20.0),
          top: false,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              ModalToolbar(
                title: Text(
                  'dialogs.language.title'.tr(),

                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                height: 52.0,
              ).sized(height: 20.0),

              const SizedBox(height: 20.0),

              StatefulBuilder(
                builder: (_, setState) {
                  return RadioGroup(
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() => currentValue = value);
                    },

                    groupValue: currentValue,

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        ...AppLanguage.values.map(
                          (e) => RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),

                            title: Text(e.label),
                            value: e,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 12.0),

              FilledButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(currentValue);
                },

                child: const Text('Confirmar'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
