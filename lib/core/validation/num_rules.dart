import 'validator.dart';

extension NumRules on Validator<num> {
  Validator<num> required([String message = 'Campo obligatorio']) {
    return addRule((v) => v == null ? message : null);
  }

  Validator<num> nonNegative([String message = 'No puede ser negativo']) {
    return addRule((v) {
      if (v != null && v < 0) return message;
      return null;
    });
  }

  Validator<num> greaterThan(num min, [String? message]) {
    return addRule((v) {
      if (v != null && v <= min) {
        return message ?? 'Debe ser mayor que $min';
      }
      return null;
    });
  }

  Validator<num> greaterOrEqual(num min, [String? message]) {
    return addRule((v) {
      if (v != null && v < min) {
        return message ?? 'Debe ser mayor o igual a $min';
      }
      return null;
    });
  }

  Validator<num> lessThan(num max, [String? message]) {
    return addRule((v) {
      if (v != null && v >= max) {
        return message ?? 'Debe ser menor que $max';
      }
      return null;
    });
  }

  Validator<num> lessOrEqual(num max, [String? message]) {
    return addRule((v) {
      if (v != null && v > max) {
        return message ?? 'Debe ser menor o igual a $max';
      }
      return null;
    });
  }

  Validator<num> between(num min, num max, [String? message]) {
    return addRule((v) {
      if (v != null && (v < min || v > max)) {
        return message ?? 'Debe estar entre $min y $max';
      }
      return null;
    });
  }

  Validator<num> maxDecimals(int decimals, [String? message]) {
    return addRule((v) {
      if (v == null) return null;

      final text = v.toString();
      if (!text.contains('.')) return null;

      final decimalPart = text.split('.').last;
      if (decimalPart.length > decimals) {
        return message ?? 'Máximo $decimals decimales';
      }
      return null;
    });
  }

  Validator<num> integerOnly([String message = 'Debe ser un número entero']) {
    return addRule((v) {
      if (v != null && v % 1 != 0) return message;
      return null;
    });
  }
}
