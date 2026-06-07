import 'package:ctrl/core/utils/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkAnswerMutationProvider = StateProvider.autoDispose(
  (_) => Mutation.initial(),
);
