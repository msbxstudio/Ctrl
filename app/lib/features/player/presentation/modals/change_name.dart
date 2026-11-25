import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';
import 'package:ctrl/shared/widgets.dart';
import 'package:msbx/validation.dart';
import 'package:msbx/widgets.dart';

Future<String?> showChangeNameSheet(
  BuildContext context, {
  required String initialValue,
}) {
  final formKey = GlobalKey<FormState>();

  final controller = TextEditingController(text: initialValue);

  return showModalPage(
    context,
    builder: (_) {
      final theme = Theme.of(context);

      final navigator = Navigator.of(
        context,
        rootNavigator: true,
      );

      return Scaffold(
        appBar: ModalToolbar(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
          height: 88.0,

          trailing: const NavigationButton.close(),

          leading: Text(
            'dialogs.username.title'.tr(),

            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).aligned(Alignment.centerLeft),
        ),

        body: Form(
          key: formKey,

          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  Text(
                    'dialogs.username.description'.tr(args: ['15']),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),

                  const SizedBox(height: 12.0),

                  TextFormField(
                    maxLength: 15,
                    controller: controller,

                    validator:
                        (Validator<String>()
                              ..required()
                              ..minLength(3)
                              ..shouldNotContain(' '))
                            .validate,

                    decoration: InputDecoration(
                      hintText: 'dialogs.username.input_hint'.tr(),
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  FilledButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      navigator.pop(controller.text);
                    },

                    child: Text('dialogs.username.confirm'.tr()),
                  ),
                ],
              ).padded(
                const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
              ),
        ),
      ).dismissKeyboard(context);
    },
  );
}
