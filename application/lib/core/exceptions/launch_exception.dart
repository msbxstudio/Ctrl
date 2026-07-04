import 'app_exception.dart';

final class LaunchException extends AppException {
  const LaunchException(super.message) : super(code: 'launch_error');
}
