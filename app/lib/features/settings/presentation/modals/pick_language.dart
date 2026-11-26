import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/config.dart';
import 'package:msbx/helpers.dart';

import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

Future<AppLanguage?> showPickLanguageSheet(
  BuildContext context, {
  required AppLanguage initialValue,
}) {
  return showModalSheet(
    context,

    constraints: const BoxConstraints(
      maxWidth: Breakpoints.small - 100.0,
    ),

    borderRadius: responsive(
      context,
      fallback: const BorderRadius.all(Radius.circular(24.0)),
      sm: null,
    ),

    builder: (_) {
      var currentValue = initialValue;

      return SafeArea(
        minimum: const EdgeInsets.all(20.0),

        left: false,
        top: false,
        right: false,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            TopAppBar(
              title: Text(
                'settings.language_picker.title'.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            Material(
              type: MaterialType.transparency,

              child: StatefulBuilder(
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

                            title: Text(e.labelKey.tr()),
                            value: e,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12.0),

            FilledButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(currentValue);
              },

              child: Text('common.actions.confirm'.tr()),
            ),
          ],
        ),
      );
    },
  );
}
