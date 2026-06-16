import 'package:ctrl/app/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigRepositoryProvider =
    StateNotifierProvider<AppConfigRepository, AppConfig>(
      (_) => throw UnimplementedError(),
    );
