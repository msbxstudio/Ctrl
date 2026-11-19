import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:msbx/msbx.dart';

import 'package:ctrl/shared/dialogs.dart';

Future<void> showLevelCompletedDialog(
  BuildContext context, {
  bool soundEffects = true,
  bool rootNavigator = true,
}) {
  if (soundEffects) {
    AudioPlayer()
        .play(
          AssetSource('audio/success.mp3'),
          mode: PlayerMode.lowLatency,
          volume: 0.2,
        )
        .ignore();
  }

  return showAppDialog(
    context,
    fullscreen: true,
    dismissible: false,
    useSafeArea: false,
    constraints: const BoxConstraints(),
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                width: 64.0,
                height: 64.0,

                child: Icon(
                  TablerIcons.check,
                  size: 48.0,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),

              const SizedBox(height: 16.0),

              Text(
                'dialogs.level.completed.title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 4.0),

              Text(
                'dialogs.level.completed.description'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ).expand(),

          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            child: Text('actions.common.next'.tr()),
          ).aligned(Alignment.center),
        ],
      ).padded(const EdgeInsets.symmetric(horizontal: 24.0)),
    ),
  );
}
