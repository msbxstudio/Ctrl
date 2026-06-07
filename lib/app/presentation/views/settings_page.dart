import 'package:ctrl/shared/widgets/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SettingsPage extends ConsumerStatefulWidget {
  static const routePath = '/settings';

  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SettingsPageState();
  }
}

final class SettingsPageState extends ConsumerState<SettingsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,

        titleSpacing: 8.0,
        title: Text('settings.title'.tr()),

        leadingWidth: 48.0,
        leading: const PopButton(),
      ),
      body: Center(child: Text('settings.content'.tr())),
    );
  }
}
