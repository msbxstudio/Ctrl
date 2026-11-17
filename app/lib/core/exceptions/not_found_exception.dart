import 'app_exception.dart';

final class NotFoundException extends AppException {
  const NotFoundException(super.message) : super(code: 'not_found_error');
}
