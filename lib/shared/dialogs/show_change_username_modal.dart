import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/validation/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'show_app_modal.dart';

final _validator = Validator<String>()
  ..minLength(3)
  ..shouldNotContain(' ');

Future<String?> showChangeUsernameModal(
  BuildContext context, {
  required String initialValue,
}) {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: initialValue);

  return showAppModal<String?>(
    context,

    child: Form(
      key: formKey,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Text(
            'dialogs.language.title'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),

          Text(
            'dialogs.language.description'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),

          TextFormField(
            maxLength: 15,
            controller: controller,
            validator: _validator.validate,

            decoration: InputDecoration(
              hintText: 'dialogs.change_username.input_hint'.tr(),
            ),
          ),

          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) {
                formKey.currentState?.save();
              }

              Navigator.of(context).pop(controller.text);
            },

            child: Text('dialogs.language.confirm'.tr()),
          ),
        ].divide(const SizedBox(height: 12.0)),
      ).padded(const EdgeInsets.symmetric(horizontal: 20.0)),
    ).dismissKeyboard(context),
  );
}
