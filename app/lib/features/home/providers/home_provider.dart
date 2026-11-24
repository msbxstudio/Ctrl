import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ctrl/features/home.dart';

final homeControllerProvider = AsyncNotifierProvider.autoDispose(() {
  return MainController();
});
