import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [SplashPage] view.
final class SplashController extends AutoDisposeAsyncNotifier<SplashData> {
  @override
  Future<SplashData> build() async {
    await Future.delayed(const Duration(seconds: 3));
    return (dummy: null);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

typedef SplashData = ({Object? dummy});
