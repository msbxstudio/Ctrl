import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:msbx/utils.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/core/services.dart';
import 'package:ctrl/core/utils.dart';
import 'package:ctrl/features/settings.dart';
import 'package:ctrl/shared/themes.dart';

final class MainApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainAppState();
  }
}

final class _MainAppState extends ConsumerState<MainApp> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    ref.listenManual(preferencesNotifierProvider, (prev, next) async {
      if (prev?.language == next.language) return;
      if (!mounted) return;

      await context.setLocale(Locale(next.language.name));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await PurchaseService.initialize(
          onDone: () {
            Debugger.log('Purchase stream finished');
          },
          onData: _handlePurchase,
          onError: (error) {
            Debugger.error('Purchase stream error: $error');
            _showPurchaseError(error, fallbackKey: 'errors.purchase.failed');
          },
        );
      } catch (error) {
        _showPurchaseError(error, fallbackKey: 'errors.purchase.start');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: _messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'CTRL',

      theme: Theme.of(context).dark,
      themeMode: ThemeMode.dark,

      localizationsDelegates: [
        ...context.localizationDelegates,
        // Easy Localization provides the legacy Flutter UI delegates.
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: context.supportedLocales,

      locale: context.locale,
      routerConfig: router,
    );
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    try {
      await _processPurchase(purchase);
    } catch (error) {
      Debugger.error('Purchase completion failed: $error');
      _showPurchaseError(error, fallbackKey: 'errors.purchase.complete');
    }
  }

  /// Displays a translated store error while this app is mounted.
  void _showPurchaseError(Object error, {required String fallbackKey}) {
    if (!mounted) return;

    _messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(errorMessage(error, fallbackKey: fallbackKey))),
    );
  }

  Future<void> _processPurchase(PurchaseDetails purchase) async {
    Debugger.log('Purchase status: ${purchase.status}');

    switch (purchase.status) {
      case PurchaseStatus.pending:
        break;

      case PurchaseStatus.canceled:
        _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('purchases.canceled'.tr())),
        );
        break;

      case PurchaseStatus.error:
        _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('errors.purchase.failed'.tr())),
        );
        break;

      default:
        await PurchaseService.instance.complete(purchase);

        _messengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('purchases.success'.tr())),
        );
        return;
    }

    if (purchase.pendingCompletePurchase) {
      await PurchaseService.instance.complete(purchase);
    }
  }
}
