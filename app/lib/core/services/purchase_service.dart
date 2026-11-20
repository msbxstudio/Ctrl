import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:msbx/contracts.dart';
import 'package:msbx/utils.dart';

import 'package:ctrl/core/exceptions.dart';

/// Manages in-app purchases through the platform's billing system.
///
/// Provides singleton access to the shared [InAppPurchase] instance.
///
/// Registers purchase stream callbacks during initialization and
/// releases its subscription during disposal.
///
/// Supports idempotent initialization, concurrent disposal,
/// and recreation after disposal.
final class PurchaseService implements Disposable {
  /// Creates a purchase service with optional purchase stream callbacks.
  new _({this.onData, this.onDone, this.onError});

  static PurchaseService? _instance;

  /// Called for each purchase update received from the purchase stream.
  final void Function(PurchaseDetails)? onData;

  /// Called when the purchase stream closes.
  final void Function()? onDone;

  /// Called when the purchase stream emits an error.
  final void Function(dynamic)? onError;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void>? _disposal;

  bool _initialized = false;
  bool _disposed = false;

  /// Whether the service has been initialized successfully.
  bool get isInitialized => _initialized && !_disposed;

  /// Whether disposal has been requested.
  @override
  bool get isDisposed => _disposed;

  /// Returns the initialized singleton instance.
  ///
  /// Throws a [StateError] if the service has not been initialized
  /// or has been disposed.
  static PurchaseService get instance {
    final instance = _instance;

    if (instance == null || !instance.isInitialized) {
      throw StateError('Purchase service is not initialized.');
    }

    return instance;
  }

  /// Returns the shared platform billing instance.
  ///
  /// Throws a [StateError] if the service has not been initialized
  /// or has been disposed.
  InAppPurchase get service {
    if (_disposed) {
      throw StateError('Purchase service has been disposed.');
    }

    if (!_initialized) {
      throw StateError('Purchase service has not been initialized.');
    }

    return InAppPurchase.instance;
  }

  /// Initializes the singleton purchase service.
  ///
  /// Registers optional callbacks for purchase updates, stream
  /// completion, and stream errors.
  ///
  /// Subsequent calls reuse the original callbacks.
  /// Waits for pending disposal before creating a new instance.
  ///
  /// Throws if the purchase stream subscription cannot be created.
  static Future<void> initialize({
    void Function(PurchaseDetails)? onData,
    void Function()? onDone,
    void Function(dynamic)? onError,
  }) {
    final current = _instance;

    if (current != null) {
      if (current._disposed) {
        return current.dispose().then(
          (_) => initialize(onData: onData, onDone: onDone, onError: onError),
        );
      }

      return Future<void>.value();
    }

    final instance = PurchaseService._(
      onData: onData,
      onDone: onDone,
      onError: onError,
    );

    _instance = instance;

    try {
      instance._subscription = InAppPurchase.instance.purchaseStream.listen(
        (details) {
          for (final detail in details) {
            instance.onData?.call(detail);
          }
        },
        onDone: () {
          instance.onDone?.call();
        },
        onError: (dynamic error) {
          instance.onError?.call(error);
        },
      );

      instance._initialized = true;

      return Future<void>.value();
    } catch (_) {
      instance._initialized = false;
      instance._disposed = true;

      if (identical(_instance, instance)) {
        _instance = null;
      }

      rethrow;
    }
  }

  /// Disposes the service and cancels its purchase stream subscription.
  ///
  /// Concurrent calls share the same disposal operation.
  ///
  /// Does not dispose the shared [InAppPurchase] instance.
  ///
  /// A disposed instance cannot be initialized again.
  @override
  Future<void> dispose() {
    return _disposal ??= _dispose();
  }

  Future<void> _dispose() async {
    _disposed = true;
    _initialized = false;

    final subscription = _subscription;
    _subscription = null;

    try {
      await subscription?.cancel();
    } finally {
      if (identical(_instance, this)) {
        _instance = null;
      }
    }
  }

  /// Requests restoration of previous purchases.
  ///
  /// Restored transactions are delivered through the purchase stream.
  /// Consumable purchases are not restored by the underlying store.
  ///
  /// Throws a [StateError] if the service is not initialized
  /// or has been disposed.
  Future<void> restore() async {
    await service.restorePurchases();
  }

  /// Initiates a purchase for the specified [productId].
  ///
  /// Queries the store for product details before starting the purchase flow.
  ///
  /// When [consumable] is `true`, initiates a consumable purchase.
  /// Otherwise, initiates a non-consumable purchase.
  ///
  /// Throws a [PurchaseException] if the product query fails, no matching
  /// product is found, or the purchase request cannot be started.
  ///
  /// Platform exceptions are logged and rethrown without modification.
  ///
  /// Purchase results are delivered asynchronously through [onData].
  /// A successful return does not indicate that the transaction completed.
  Future<void> purchase(String productId, {bool consumable = true}) async {
    final response = await service.queryProductDetails({productId});

    if (response.error != null) {
      throw const PurchaseException('Failed to query product details.');
    }

    if (response.productDetails.isEmpty) {
      throw const PurchaseException(
        'No product details found for the given product ID.',
      );
    }

    final param = PurchaseParam(productDetails: response.productDetails.first);

    try {
      final success = consumable
          ? await service.buyConsumable(purchaseParam: param)
          : await service.buyNonConsumable(purchaseParam: param);

      if (!success) {
        throw const PurchaseException('Failed to initiate purchase.');
      }
    } catch (error) {
      Debugger.error('Purchase failed: $error');
      rethrow;
    }
  }

  /// Completes the specified [purchase] with the platform's billing system.
  ///
  /// Call after processing and validating a purchase that requires completion.
  ///
  /// Throws a [StateError] if the service is not initialized
  /// or has been disposed.
  Future<void> complete(PurchaseDetails purchase) async {
    await service.completePurchase(purchase);
  }
}
