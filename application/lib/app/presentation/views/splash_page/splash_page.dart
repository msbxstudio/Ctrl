import 'package:ctrl/app/index.dart';
import 'package:ctrl/core/extensions/index.dart';
import 'package:ctrl/core/utils/index.dart';
import 'package:ctrl/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class SplashPage extends ConsumerStatefulWidget {
  static const routePath = '/splash';

  const SplashPage({super.key});

  @override
  ConsumerState createState() {
    return _SplashPageState();
  }
}

final class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(splashControllerProvider, (_, next) {
      next.maybeWhen(
        data: (status) {
          ref.read(goRouterProvider).replace('/');
        },
        orElse: () {
          Debugger.log('SplashPage: No data yet');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(splashControllerProvider);

    return Scaffold(
      body: AnimatedLogo(enabled: asyncValue.isLoading).centered(),
    );
  }
}
