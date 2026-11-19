import 'package:ctrl/features/level.dart';
import 'package:easy_localization/easy_localization.dart';

final class LevelHintModel extends LevelHint {
  const LevelHintModel({required super.type, required super.value});

  factory LevelHintModel.fromJson(Map<String, dynamic> json) {
    return LevelHintModel(
      type: switch (json['type']) {
        'key' => HintType.key,
        'raw' => HintType.raw,
        _ => throw Exception('Unknown hint type.'),
      },
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': switch (type) {
        HintType.key => 'key',
        HintType.raw => 'raw',
      },
      'value': value,
    };
  }

  @override
  String resolve() {
    return switch (type) {
      HintType.key => value.tr(),
      _ => value,
    };
  }
}
