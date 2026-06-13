import 'validator.dart';

extension BoolRules on Validator<bool> {
  Validator<bool> mustBeTrue([String message = 'Debes aceptar los términos']) {
    return addRule((v) => (v ?? false) ? null : message);
  }
}
