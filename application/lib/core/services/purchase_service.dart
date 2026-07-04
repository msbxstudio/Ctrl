import 'dart:io';

import 'package:ctrl/core/exceptions/index.dart';
import 'package:ctrl/core/utils/index.dart';

import 'package:flutter/services.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'app_service.dart';

/// A service class that manages in-app purchases using the `in_app_purchase` package.
final class PurchaseService extends AppService<InAppPurchase> {
  static final instance = PurchaseService._();

  PurchaseService._() : super(InAppPurchase.instance);

  /// Initializes the purchase service by setting up listeners for purchase updates.
  @override
  void initialize({
    void Function()? onDone,
    void Function(PurchaseDetails purchase)? onData,
    void Function(dynamic error)? onError,
  }) async {
    if (isInitialized || !await service!.isAvailable()) {
      return;
    }

    _listenToPurchaseUpdated(onDone: onDone, onData: onData, onError: onError);
    setInitialized(true);
  }

  /// Disposes the purchase service by marking it as uninitialized.
  @override
  void dispose() {
    setInitialized(false);
  }

  /// Restores previous purchases for the user.
  Future<void> restore() async {
    await service!.restorePurchases();
  }

  /// Initiates the purchase flow for a consumable or non-consumable product.
  Future<void> purchase(String productId, {bool consumable = true}) async {
    if (!await service!.isAvailable()) {
      throw const PurchaseException(
        'In-app purchases are not available on this device',
      );
    }

    final response = await service!.queryProductDetails({productId});

    if (response.error is IAPError) {
      throw const PurchaseException('Failed to query product details');
    }

    if (response.productDetails.isEmpty) {
      throw const PurchaseException(
        'No product details found for the given product ID',
      );
    }

    final param = PurchaseParam(productDetails: response.productDetails.first);

    try {
      final result = consumable
          ? await service!.buyConsumable(purchaseParam: param)
          : await service!.buyNonConsumable(purchaseParam: param);

      if (!result) {
        throw const PurchaseException('Purchase failed');
      }
    } on PlatformException catch (e) {
      if (e.code == 'storekit_duplicate_product_object') {
        // On iOS, fetch unfinished transactions from the payment queue directly.
        // restorePurchases() only re-delivers completed/restored purchases, NOT pending ones.
        if (Platform.isIOS) {
          final transactions = await SKPaymentQueueWrapper().transactions();

          for (final tx in transactions) {
            await SKPaymentQueueWrapper().finishTransaction(tx);
          }
        }
      }
    } catch (e) {
      Debugger.error('Purchase failed: $e');
      rethrow;
    }
  }

  /// Completes a purchase by acknowledging it with the underlying platform's billing system.
  Future<void> complete(PurchaseDetails purchase) async {
    await service!.completePurchase(purchase);
  }

  /// Listens to purchase updates from the underlying platform's billing system.
  void _listenToPurchaseUpdated({
    void Function()? onDone,
    void Function(PurchaseDetails details)? onData,
    void Function(dynamic error)? onError,
  }) {
    service!.purchaseStream.listen(
      (details) {
        for (final detail in details) {
          onData?.call(detail);
        }
      },
      onDone: () {
        onDone?.call();
      },
      onError: (e) {
        onError?.call(e);
      },
    );
  }
}
