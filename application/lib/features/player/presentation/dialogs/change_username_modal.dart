import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/validation/index.dart';
import 'package:ctrl/shared/dialogs/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

final _validator = Validator<String>()
  ..required()
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
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: 400.0),

    child: Form(
      key: formKey,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Text(
            'dialogs.username.title'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),

          Text(
            'dialogs.username.description'.tr(args: ['15']),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),

          TextFormField(
            maxLength: 15,
            controller: controller,
            validator: _validator.validate,

            decoration: InputDecoration(
              hintText: 'dialogs.username.input_hint'.tr(),
            ),
          ),

          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState?.save();
                Navigator.of(context).pop(controller.text);
              }
            },

            child: Text('dialogs.username.confirm'.tr()),
          ),
        ].divide(const SizedBox(height: 12.0)),
      ).padded(const EdgeInsets.symmetric(horizontal: 20.0)),
    ).dismissKeyboard(context),
  );
}
