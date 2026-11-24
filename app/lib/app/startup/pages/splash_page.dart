import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:msbx/extensions.dart';
import 'package:msbx/helpers.dart';

import 'package:ctrl/app/router.dart';
import 'package:ctrl/app/startup.dart';
import 'package:ctrl/shared/widgets.dart';

import 'splash_page_error.dart';

final class SplashPage extends ConsumerStatefulWidget {
  const new({super.key});

  static const routePath = '/splash';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SplashPageState();
  }
}

final class _SplashPageState extends ConsumerState<SplashPage> {
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
    final controller = ref.read(splashControllerProvider.notifier);
    final value = ref.watch(splashControllerProvider);

    return value.maybeWhen(
      error: (err, _) {
        return SplashPageError(
          onRetry: () async {
            await controller.refresh();
          },
          error: err,
        );
      },

      orElse: () {
        final size = scaledSize(context, scale: 0.325);

        return Scaffold(
          body:
              Center(
                child: AnimatedChild.scale(
                  controller: _controller,
                  child: SvgPicture.asset(
                    'assets/images/icon-white.svg',
                    width: size,
                    height: size,
                  ),
                ),
              ).padded(
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
        );
      },
    );
  }
}
