import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

/// Controls the animation of an [AnimatedChild].
/// Controls the playback of an attached animated widget.
final class MotionController extends ChangeNotifier {
  _AnimatedChildState? _state;

  /// Whether the controller is attached to a widget.
  bool get isAttached => _state != null;

  /// Whether the animation is currently running.
  bool get isAnimating => _state?._controller.isAnimating ?? false;

  /// Starts the animation forward.
  void forward() {
    _state?._controller.forward();
  }

  /// Starts the animation in reverse.
  void reverse() {
    _state?._controller.reverse();
  }

  /// Repeats the animation.
  void repeat({bool reverse = true}) {
    _state?._controller.repeat(reverse: reverse);
  }

  /// Stops the animation.
  void stop() {
    _state?._controller.stop();
  }

  /// Resets the animation to its initial value.
  void reset() {
    _state?._controller.reset();
  }

  /// Attaches the controller to a widget.
  void _attach(_AnimatedChildState state) {
    assert(
      _state == null || identical(_state, state),
      'MotionController is already attached to another widget.',
    );

    _state = state;
    notifyListeners();
  }

  /// Detaches the controller from a widget.
  void _detach(_AnimatedChildState state) {
    if (identical(_state, state)) {
      _state = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _state = null;
    super.dispose();
  }
}

final class AnimatedChild extends StatefulWidget {
  const new scale({
    super.key,
    required this.child,
    this.begin = 1.0,
    this.end = 0.7,
    this.controller,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(seconds: 2),
  });

  final Widget child;

  final double begin;

  final double end;

  final Curve curve;

  final Duration duration;

  final MotionController? controller;

  @override
  State<StatefulWidget> createState() {
    return _AnimatedChildState();
  }
}

final class _AnimatedChildState extends State<AnimatedChild>
    with SingleTickerProviderStateMixin {
  /// ...
  late final AnimationController _controller;

  /// ...
  late final Animation<double> _animation;

  // void forward() {
  //   _controller.forward();
  // }

  // void reverse() {
  //   _controller.reverse();
  // }

  // void repeat() {
  //   _controller.repeat(reverse: true);
  // }

  // void stop() {
  //   _controller.stop();
  // }

  // void reset() {
  //   _controller.reset();
  // }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant AnimatedChild oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.begin != widget.begin ||
        oldWidget.end != widget.end ||
        oldWidget.curve != widget.curve) {
      _animation = Tween<double>(
        begin: widget.begin,
        end: widget.end,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext _) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
