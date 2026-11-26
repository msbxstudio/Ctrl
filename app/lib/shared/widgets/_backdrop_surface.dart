// import 'dart:ui' as ui;

// import 'package:cupertino_ui/cupertino_ui.dart';
// import 'package:material_ui/material_ui.dart';

// /// A customizable surface that filters the content behind it.
// final class BackdropSurface extends StatelessWidget {
//   const new({
//     super.key,
//     required this.child,
//     this.tint = Colors.transparent,
//     this.blurSigma = 20.0,
//     this.saturation = 1.0,
//     this.border,
//     this.padding,
//     this.borderRadius = BorderRadius.zero,
//   }) : assert(blurSigma >= 0.0),
//        assert(saturation >= 0.0);

//   /// The widget displayed above the filtered backdrop.
//   final Widget child;

//   /// The color painted over the filtered backdrop.
//   final Color tint;

//   /// The standard deviation of the Gaussian blur.
//   final double blurSigma;

//   /// The saturation multiplier applied to the backdrop.
//   ///
//   /// A value of 0.0 produces grayscale, 1.0 preserves the
//   /// original saturation, and higher values increase it.
//   final double saturation;

//   /// The border painted around the surface.
//   final BoxBorder? border;

//   /// The space between the surface and its child.
//   final EdgeInsetsGeometry? padding;

//   /// The corner radius of the surface.
//   final BorderRadiusGeometry borderRadius;

//   ui.ColorFilter get _saturationFilter {
//     final inverse = 1.0 - saturation;

//     final r = 0.2126 * inverse;
//     final g = 0.7152 * inverse;
//     final b = 0.0722 * inverse;

//     return ui.ColorFilter.matrix([
//       r + saturation,
//       g,
//       b,
//       0,
//       0,
//       r,
//       g + saturation,
//       b,
//       0,
//       0,
//       r,
//       g,
//       b + saturation,
//       0,
//       0,
//       0,
//       0,
//       0,
//       1,
//       0,
//     ]);
//   }

//   ui.ImageFilter get _filter {
//     return ui.ImageFilter.compose(
//       outer: ui.ImageFilter.blur(
//         sigmaX: blurSigma,
//         sigmaY: blurSigma,
//       ),
//       inner: _saturationFilter,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: borderRadius,
//       child: BackdropFilter(
//         filter: _filter,
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//             color: tint,
//             borderRadius: borderRadius,
//             border: border,
//           ),
//           child: Material(
//             type: MaterialType.transparency,
//             child: Padding(
//               padding: padding ?? EdgeInsets.zero,
//               child: child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// A translucent surface inspired by Cupertino materials.
// final class CupertinoSurface extends StatelessWidget {
//   const new({
//     super.key,
//     required this.child,
//     this.tint,
//     this.blurSigma = 20.0,
//     this.saturation = 1.8,
//     this.border,
//     this.padding,
//     this.borderRadius = BorderRadius.zero,
//   });

//   final Widget child;
//   final Color? tint;
//   final double blurSigma;
//   final double saturation;
//   final BoxBorder? border;
//   final EdgeInsetsGeometry? padding;
//   final BorderRadiusGeometry borderRadius;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return BackdropSurface(
//       tint:
//           tint ?? (isDark ? const Color(0xB31C1C1E) : const Color(0xB3FFFFFF)),
//       blurSigma: blurSigma,
//       saturation: saturation,
//       border: border,
//       padding: padding,
//       borderRadius: borderRadius,
//       child: child,
//     );
//   }
// }

// /// A translucent surface inspired by Windows Acrylic materials.
// final class AcrylicSurface extends StatelessWidget {
//   const new({
//     super.key,
//     required this.child,
//     this.tint,
//     this.blurSigma = 30.0,
//     this.saturation = 1.5,
//     this.noiseOpacity = 0.035,
//     this.borderRadius = BorderRadius.zero,
//     this.noiseTexture,
//     this.border,
//     this.padding,
//   }) : assert(noiseOpacity >= 0.0 && noiseOpacity <= 1.0);

//   final Widget child;
//   final Color? tint;
//   final double blurSigma;
//   final double saturation;
//   final double noiseOpacity;
//   final BorderRadiusGeometry borderRadius;
//   final ImageProvider? noiseTexture;
//   final BoxBorder? border;
//   final EdgeInsetsGeometry? padding;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return BackdropSurface(
//       tint:
//           tint ?? (isDark ? const Color(0x991C1C1C) : const Color(0x99FFFFFF)),
//       blurSigma: blurSigma,
//       saturation: saturation,
//       borderRadius: borderRadius,
//       border: border,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           image: noiseTexture != null
//               ? DecorationImage(
//                   image: noiseTexture!,
//                   repeat: ImageRepeat.repeat,
//                   opacity: noiseOpacity,
//                 )
//               : null,
//         ),
//         child: Padding(
//           padding: padding ?? EdgeInsets.zero,
//           child: child,
//         ),
//       ),
//     );
//   }
// }

// /// A translucent glass-like surface with a blurred backdrop.
// ///
// /// Combines backdrop blur, saturation, a translucent tint,
// /// and an optional border to create a frosted glass effect.
// final class GlassSurface extends StatelessWidget {
//   /// Creates a customizable glass surface.
//   const new({
//     super.key,
//     required this.child,
//     this.tint,
//     this.border,
//     this.padding,
//     this.blurSigma = 12.0,
//     this.saturation = 1.2,
//     this.borderRadius = BorderRadius.zero,
//   }) : assert(blurSigma >= 0.0),
//        assert(saturation >= 0.0);

//   /// The widget displayed above the glass surface.
//   final Widget child;

//   /// The translucent color applied over the backdrop.
//   ///
//   /// If null, a tint based on the current theme brightness is used.
//   final Color? tint;

//   /// The border painted around the glass surface.
//   ///
//   /// If null, a subtle translucent border is used.
//   final BoxBorder? border;

//   /// The space between the surface and its child.
//   final EdgeInsetsGeometry? padding;

//   /// The standard deviation of the Gaussian blur.
//   final double blurSigma;

//   /// The saturation multiplier applied to the backdrop.
//   final double saturation;

//   /// The corner radius of the glass surface.
//   final BorderRadiusGeometry borderRadius;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return BackdropSurface(
//       tint:
//           tint ?? (isDark ? const Color(0x261C1C1E) : const Color(0x33FFFFFF)),
//       blurSigma: blurSigma,
//       saturation: saturation,
//       borderRadius: borderRadius,
//       border:
//           border ??
//           Border.all(
//             color: Colors.white.withValues(
//               alpha: isDark ? 0.15 : 0.35,
//             ),
//             width: 1.0,
//           ),
//       padding: padding,
//       child: child,
//     );
//   }
// }
