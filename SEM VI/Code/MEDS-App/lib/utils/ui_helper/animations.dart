import 'package:flutter/material.dart';

/// A collection of helper methods and custom route builders for standard animations.
class AppAnimations {
  /// Returns a [FadeTransition] for the given [child] using the provided [animation].
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Returns a [SlideTransition] for the given [child] using the provided [animation].
  /// The [begin] offset defines the start position.
  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation, // Changed from Animation<Offset> to Animation<double>
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Returns a [ScaleTransition] for the given [child] using the provided [animation].
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Returns a [RotationTransition] for the given [child] using the provided [animation].
  static Widget rotationTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return RotationTransition(
      turns: animation,
      child: child,
    );
  }
}

/// A custom [PageRoute] that fades between pages.
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AppAnimations.fadeTransition(child: child, animation: animation);
          },
        );
}

/// A custom [PageRoute] that slides the new page in from the right.
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset beginOffset;
  SlidePageRoute({
    required this.page,
    this.beginOffset = const Offset(1.0, 0.0),
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return AppAnimations.slideTransition(
              child: child,
              animation: animation,
              begin: beginOffset,
            );
          },
        );
}

/// A custom [PageRoute] that scales the new page up while fading it in.
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  ScaleFadePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}
