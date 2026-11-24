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

    final size = scaledSize(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),

        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: AnimatedChild.scale(
                  controller: _controller,
                  child: SvgPicture.asset(
                    'assets/images/icon-white.svg',
                    width: size,
                    height: size,
                  ),
                ),
              ),
            ),

            ...value.whenOrNull(
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,

                  error: (_, _) {
                    final theme = Theme.of(context);

                    return [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 12.0,

                        children: [
                          Text(
                            'Problema grave',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),

                          Text(
                            'La app no pudo iniciarse correctamente.'
                            ' '
                            'Restablecerla podría solucionar el problema, pero eliminará tu progreso guardado en este dispositivo.',
                            textAlign: TextAlign.center,

                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ).padded(const EdgeInsets.only(bottom: 16.0)),

                          FilledButton(
                            onPressed: () async {
                              await controller.refresh();
                            },
                            child: const Text('Restablecer app'),
                          ),

                          ElevatedButton(
                            onPressed: () async {
                              await controller.refresh();
                            },

                            style: theme.elevatedButtonTheme.style?.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                theme.colorScheme.outlineVariant.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                            ),

                            child: const Text('Salir'),
                          ),
                        ],
                      ),
                    ];
                  },
                ) ??
                [],
          ],
        ),
      ),
    );
  }
}
