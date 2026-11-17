// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final class ResponsiveBuilder extends ConsumerWidget {
//   static const mobileMax = 600.0;
//   static const tabletMax = 1024.0;

//   final Widget Function(BuildContext context)? onMobile;
//   final Widget Function(BuildContext context)? onTablet;
//   final Widget Function(BuildContext context)? onDesktop;
//   final Widget Function(BuildContext context)? fallback;

//   const ResponsiveBuilder({
//     super.key,
//     this.onMobile,
//     this.onTablet,
//     this.onDesktop,
//     this.fallback,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef _) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth;

//         if (width >= tabletMax && onDesktop != null) {
//           return onDesktop!(context);
//         }

//         if (width >= mobileMax && onTablet != null) {
//           return onTablet!(context);
//         }

//         if (onMobile != null) {
//           return onMobile!(context);
//         }

//         return fallback?.call(context) ?? const SizedBox.shrink();
//       },
//     );
//   }
// }
