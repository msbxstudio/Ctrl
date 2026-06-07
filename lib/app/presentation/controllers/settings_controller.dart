import 'package:ctrl/app/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for [SettingsPage] view.
final class SettingsController extends AutoDisposeAsyncNotifier<SettingsData> {
  @override
  Future<SettingsData> build() async {
    return await Future.value((dummy: null));
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

typedef SettingsData = ({Object? dummy});
