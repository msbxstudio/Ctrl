import 'validator.dart';

extension StringRules on Validator<String> {
  Validator<String> required([String message = 'Campo obligatorio']) {
    return addRule((v) => (v == null || v.trim().isEmpty) ? message : null);
  }

  Validator<String> minLength(int min, [String? message]) {
    return addRule(
      (v) => (v != null && v.length < min)
          ? (message ?? 'Mínimo $min caracteres')
          : null,
    );
  }

  Validator<String> minLengthIfPresent(int min, [String? message]) {
    return addRule((v) {
      if (v == null || v.trim().isEmpty) return null;
      if (v.length < min) {
        return message ?? 'Mínimo $min caracteres';
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
          ? (message ?? 'Debe contener "$substring"')
          : null,
    );
  }

  Validator<String> shouldNotContain(String substring, [String? message]) {
    return addRule(
      (v) => (v != null && v.contains(substring))
          ? (message ?? 'No debe contener "$substring"')
          : null,
    );
  }

  Validator<String> isDouble([String message = 'Debe ser un número']) {
    return addRule((v) => double.tryParse(v ?? '') == null ? message : null);
  }
}
