import 'app_exception.dart';

final class UnknownException extends AppException {
  const UnknownException([String? message])
    : super(
        code: 'unknown_error',
        message ??
            'Ocurrió un error inesperado.'
                '\n'
                'Inténtalo de nuevo más tarde.',
      );
}
