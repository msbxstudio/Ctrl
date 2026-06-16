import 'package:easy_localization/easy_localization.dart';

import 'validator.dart';

extension StringRules on Validator<String> {
  Validator<String> required([String? message]) {
    return addRule(
      (v) => (v == null || v.trim().isEmpty)
          ? (message ?? 'validators.string.required'.tr())
          : null,
    );
  }

  Validator<String> minLength(int min, [String? message]) {
    return addRule(
      (v) => (v != null && v.length < min)
          ? (message ??
                'validators.string.min_length'.tr(args: [min.toString()]))
          : null,
    );
  }

  Validator<String> minLengthIfPresent(int min, [String? message]) {
    return addRule((v) {
      if (v == null || v.trim().isEmpty) return null;
      if (v.length < min) {
        return message ?? 'validators.min_length'.tr(args: [min.toString()]);
      }
      return null;
    });
  }

  Validator<String> maxLength(int max, [String? message]) {
    return addRule(
      (v) => (v != null && v.length > max)
          ? (message ??
                'validators.string.max_length'.tr(args: [max.toString()]))
          : null,
    );
  }

  Validator<String> maxLengthIfPresent(int max, [String? message]) {
    return addRule((v) {
      if (v == null || v.trim().isEmpty) return null;
      if (v.length > max) {
        return message ??
            'validators.string.max_length'.tr(args: [max.toString()]);
      }
      return null;
    });
  }

  Validator<String> email([String message = 'Correo inválido']) {
    return addRule((v) {
      if (v == null || v.trim().isEmpty) return message;
      // ignore: deprecated_member_use
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(v) ? null : message;
    });
  }

  Validator<String> matches(
    String Function() otherValueGetter, [
    String message = 'No coincide',
  ]) {
    return addRule((v) => v != otherValueGetter() ? message : null);
  }

  Validator<String> shouldContain(String substring, [String? message]) {
    return addRule(
      (v) => (v != null && !v.contains(substring))
          ? (message ??
                'validators.string.should_contain'.tr(args: [substring]))
          : null,
    );
  }

  Validator<String> shouldNotContain(String substring, [String? message]) {
    return addRule(
      (v) => (v != null && v.contains(substring))
          ? (message ??
                'validators.string.should_not_contain'.tr(args: [substring]))
          : null,
    );
  }

  Validator<String> isDouble([String message = 'Debe ser un número']) {
    return addRule((v) => double.tryParse(v ?? '') == null ? message : null);
  }
}
