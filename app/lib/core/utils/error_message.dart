import 'package:easy_localization/easy_localization.dart';
import 'package:msbx/exceptions.dart';

/// Resolves a known error key or an operation-specific fallback for display.
///
/// Application exceptions carry keys instead of translated copy so the message
/// uses the current language. Unrecognized errors never expose diagnostics.
String errorMessage(Object? error, {required String fallbackKey}) {
  if (error is AppException &&
      error.message.startsWith('errors.') &&
      trExists(error.message)) {
    return error.message.tr();
  }

  return fallbackKey.tr();
}
