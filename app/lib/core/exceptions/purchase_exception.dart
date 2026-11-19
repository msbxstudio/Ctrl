import 'package:msbx/msbx.dart';

final class PurchaseException extends AppException {
  const new(super.message) : super(code: 'purchase_error');
}
