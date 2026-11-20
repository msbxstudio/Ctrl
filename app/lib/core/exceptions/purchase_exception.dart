import 'package:msbx/exceptions.dart';

final class PurchaseException extends AppException {
  const new(super.message) : super(code: 'purchase_error');
}
