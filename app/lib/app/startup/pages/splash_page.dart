import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/helpers.dart';

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
  static const _source = 'assets/images/icon-white.svg';

  late final MotionController _controller;

  @override
  void initState() {
    super.initState();

    _controller = MotionController();

    ref.listenManual(splashControllerProvider, (_, next) {
      if (!next.isLoading) _controller.stop();

      next.whenOrNull(
        data: (state) async {
          if (!context.mounted) return;

          await context.setLocale(Locale(state.language.name));
          await ref.read(routerProvider).replace('/');
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext _) {
    final _ = ref.watch(splashControllerProvider);

    final size = scaledSize(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,

          children: [
            Expanded(
              child: Center(
                child: AnimatedChild.scale(
                  controller: _controller,
                  child: SvgPicture.asset(_source, width: size, height: size),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
