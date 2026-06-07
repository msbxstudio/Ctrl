import 'dart:convert';

import 'package:ctrl/features/level/index.dart';
import 'package:flutter/services.dart';

final class LevelRepositoryImpl implements LevelRepository {
  final _levels = <Level>[];

  LevelRepositoryImpl();

  @override
  Future<List<Level>> getAll() async {
    if (_levels.isNotEmpty) {
      return await Future.value(_levels);
    }

    final jsonString = await rootBundle.loadString('assets/data/levels.json');

    final jsonData = jsonDecode(jsonString) as List<dynamic>;

    _levels.addAll(jsonData.map((e) => LevelModel.fromJson(e)).toList());
    return _levels;
  }

  @override
  Future<Level> getOne({required int id}) async {
    await getAll();
    return await Future.value(_levels.where((l) => l.id == id).first);
  }

  @override
  Future<Level> getCurrent() async {
    return await Future.value(_levels.firstWhere((l) => l.id == 22));
  }

  @override
  Future<Level> update(String id, {required Level level}) {
    return Future.value(level);
  }
}
