import 'app_exception.dart';

final class UnhandledException extends AppException {
  const UnhandledException(super.message) : super(code: 'unhandled_error');
}
