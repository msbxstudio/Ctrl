import 'app_exception.dart';

final class PurchaseException extends AppException {
  const PurchaseException(super.message) : super(code: 'purchase_error');
}
