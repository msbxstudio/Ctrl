import 'package:audioplayers/audioplayers.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/shared/dialogs/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

Future<void> showLevelCompletedDialog(
  BuildContext context, {
  required String hint,
  bool rootNavigator = true,
}) {
  AudioPlayer()
      .play(
        AssetSource('audio/success.mp3'),
        mode: PlayerMode.lowLatency,
        volume: 0.7,
      )
      .ignore();

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

              Text(hint, style: Theme.of(context).textTheme.headlineMedium),
              Text(hint, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ).expand(),

          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },

            child: Text('actions.common.ok'.tr()),
          ).aligned(Alignment.center),
        ],
      ),
    ),
  );
}
