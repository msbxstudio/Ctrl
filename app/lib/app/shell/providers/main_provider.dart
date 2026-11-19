import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ctrl/app/shell.dart';

final mainControllerProvider = AsyncNotifierProvider.autoDispose(() {
  return MainController();
});
