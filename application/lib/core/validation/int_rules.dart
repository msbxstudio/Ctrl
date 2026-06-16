import 'validator.dart';

extension IntRules on Validator<int> {
  Validator<int> required([String message = 'Selecciona una opción']) {
    return addRule((v) => v == null ? message : null);
  }
}
