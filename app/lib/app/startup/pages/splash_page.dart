import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msbx/extensions.dart';
import 'package:msbx/utils.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/app/startup.dart';
import 'package:ctrl/shared/widgets.dart';

final class SplashPage extends ConsumerStatefulWidget {
  const new({super.key});

  static const routePath = '/splash';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
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
          ref.read(routerProvider).replace('/');
        },
        orElse: () {
          Debugger.log('SplashPage: No data yet');
        },
      );
    });
  }

  @override
  Widget build(BuildContext _) {
    final asyncValue = ref.watch(splashControllerProvider);

    return Scaffold(
      body: AnimatedLogo(enabled: asyncValue.isLoading).centered(),
    );
  }
}
