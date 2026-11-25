import 'package:msbx/exceptions.dart';

/// Identifies a store failure using a user-facing localization key.
final class PurchaseException extends AppException {
  /// Creates a purchase failure resolved by the presentation layer.
  const new(super.message) : super(code: 'purchase_error');
}
