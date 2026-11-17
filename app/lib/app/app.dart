import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/services/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/shared/theme/index.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:in_app_purchase/in_app_purchase.dart';

final class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState createState() {
    return _MainAppState();
  }
}

final class _MainAppState extends ConsumerState<MainApp> {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DatabaseService.instance.initialize();
      PurchaseService.instance.initialize(
        onDone: () {
          Debugger.log('Purchase stream finished');
        },
        onData: _handlePurchase,
        onError: (error) {
          Debugger.error('Purchase stream error: $error');
        },
      );
    });
  }

  @override
  void dispose() {
    DatabaseService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'CTRL',

      theme: Theme.of(context).dark,
      themeMode: ThemeMode.dark,

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,

      locale: context.locale,
      routerConfig: router,
    );
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    Debugger.log('Purchase status: ${purchase.status}');

    switch (purchase.status) {
      case PurchaseStatus.pending:
        break;

      case PurchaseStatus.canceled:
        messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('snackbar.purchase_canceled'.tr())),
        );
        break;

      case PurchaseStatus.error:
        messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('snackbar.purchase_failed'.tr())),
        );
        break;

      default:
        await PurchaseService.instance.complete(purchase);

        messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('snackbar.purchase_success'.tr())),
        );
    }

    if (purchase.pendingCompletePurchase) {
      await PurchaseService.instance.complete(purchase);
    }
  }
}
