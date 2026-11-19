import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final class AnimatedLogo extends ConsumerStatefulWidget {
  const new({super.key, this.enabled = true});

  final bool enabled;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AnimatedLogoState();
  }
}

final class _AnimatedLogoState extends ConsumerState<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final src = 'assets/images/icon-white.svg';
    final size = calculateSize(context);
    return Center(
      child: widget.enabled
          ? ScaleTransition(
              scale: animation,
              child: SvgPicture.asset(src, width: size, height: size),
            )
          : SvgPicture.asset(src, width: size, height: size),
    );
  }

  /// Returns a responsive icon size based on the screen's shortest side.
  /// Uses about 40% of that dimension for consistent scaling.
  double calculateSize(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return min(shortestSide * 0.3, 300.0);
  }
}
