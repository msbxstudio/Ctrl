import 'validator.dart';

extension ListRules<T> on Validator<List<T>> {
  Validator<List<T>> required([String message = 'Campo obligatorio']) {
    return addRule((v) {
      if (v == null || v.isEmpty) return message;
      return null;
    });
  }

  Validator<List<T>> minLength(int min, [String? message]) {
    return addRule((v) {
      if (v != null && v.length < min) {
        return message ?? 'Mínimo $min elementos';
      }
      return null;
    });
  }

  Validator<List<T>> minLengthIfPresent(int min, [String? message]) {
    return addRule((v) {
      if (v == null || v.isEmpty) return null;
      if (v.length < min) {
        return message ?? 'Mínimo $min elementos';
      }
      return null;
    });
  }

  Validator<List<T>> maxLength(int max, [String? message]) {
    return addRule((v) {
      if (v != null && v.length > max) {
        return message ?? 'Máximo $max elementos';
      }
      return null;
    });
  }

  Validator<List<T>> lengthEquals(int length, [String? message]) {
    return addRule((v) {
      if (v != null && v.length != length) {
        return message ?? 'Debe tener $length elementos';
      }
      return null;
    });
  }
}
