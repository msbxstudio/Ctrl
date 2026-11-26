import 'dart:io';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/config.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';
import 'package:msbx/widgets.dart';

import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/widgets.dart';

Future<T?> showModalSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  BoxConstraints? constraints,
  BoxBorder? border,
  bool dismissible = true,
  bool draggable = true,
  bool adaptive = true,
}) {
  Widget sheetBuilder(BuildContext c) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,

      color: Colors.transparent,
      constraints: constraints,

      child: ClipRRect(
        borderRadius:
            borderRadius ??
            const BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),

        child: Surface.acrylic(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (draggable) const DragHandle(),
              builder.call(c),
            ],
          ),
        ),
      ),
    );
  }

  // Use a Cupertino modal popup on iOS when adaptive presentation is enabled.
  return Platform.isIOS && adaptive
      ? showCupertinoModalPopup<T>(
          context: context,
          barrierDismissible: dismissible,
          useRootNavigator: true,
          builder: sheetBuilder,
        )
      // Use a Material bottom sheet on other platforms or when adaptation is
      // disabled.
      : showModalBottomSheet<T>(
          context: context,
          isDismissible: dismissible,

          backgroundColor: Colors.transparent,
          barrierColor: Colors.transparent,
          elevation: 0.0,

          isScrollControlled: true,
          useRootNavigator: true,
          showDragHandle: false,

          builder: sheetBuilder,
        );
}

Future<AppLanguage?> showPickLanguageSheet(
  BuildContext context, {
  required AppLanguage initialValue,
}) {
  return showModalSheet(
    context,
    constraints: const BoxConstraints(
      maxWidth: Breakpoints.small,
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
            ModalToolbar(
              title: Text(
                'settings.language_picker.title'.tr(),

                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              height: 56.0,
            ).sized(height: 24.0),

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
