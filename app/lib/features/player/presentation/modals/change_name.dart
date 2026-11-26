import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/config.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';
import 'package:msbx/validation.dart';

import 'package:ctrl/shared/widgets.dart';

final _nameFieldValidator = Validator<String>()
  ..required('validation.required'.tr())
  ..minLength(
    3,
    'validation.min_length'.tr(
      namedArgs: {'min': '3'},
    ),
  )
  ..maxLength(
    15,
    'validation.max_length'.tr(
      namedArgs: {'max': '15'},
    ),
  )
  ..shouldNotContain(
    ' ',
    'validation.no_spaces'.tr(),
  );

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
        appBar: TopAppBar(
          trailing:
              NavigationButton.close(
                tooltip: 'common.actions.cancel'.tr(),
              ).padded(
                const EdgeInsets.only(top: 16.0, right: 16.0),
              ),

          title: Text(
            'player.change_name.title'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Form(
          key: formKey,

          child:
              Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      Text(
                        'player.change_name.description'.tr(
                          namedArgs: {'max': '15'},
                        ),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),

                      const SizedBox(height: 12.0),

                      TextFormField(
                        maxLength: 15,
                        controller: controller,

                        validator: (text) {
                          return _nameFieldValidator.validate(text);
                        },

                        decoration: InputDecoration(
                          hintText: 'player.change_name.input_hint'.tr(),
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      FilledButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          navigator.pop(controller.text);
                        },

                        child: Text('common.actions.confirm'.tr()),
                      ),
                    ],
                  )
                  .padded(
                    responsive(
                      context,
                      fallback: const EdgeInsets.symmetric(vertical: 12.0),
                      sm: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                    ),
                  )
                  .constrained(
                    maxWidth: Breakpoints.small,
                  )
                  .centered(),
        ),
      ).dismissKeyboard(context);
    },
  );
}
