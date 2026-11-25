import 'package:ctrl/features/level.dart';

final class HintModel {
  const new({
    required this.type,
    required this.value,
  });

  ///
  final HintType type;

  ///
  final String value;

  factory fromMap(Map<String, dynamic> map) {
    return HintModel(
      type: HintType.fromDbValue(map['type'] as String),
      value: map['value'] as String,
    );
  }

  factory fromEntity(Hint entity) {
    return HintModel(type: entity.type, value: entity.value);
  }

  Map<String, dynamic> toMap() {
    return {'type': type.toDbValue(), 'value': value};
  }

  Hint toEntity() {
    return Hint(type: type, value: value);
  }
}
