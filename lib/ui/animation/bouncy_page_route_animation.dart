import 'package:flutter/material.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;

  BouncyPageRoute({required this.widget})
      : super(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) {
              return widget;
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.bounceOut);
              return ScaleTransition(
                  scale: animation, alignment: Alignment.center, child: child);
            });
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget widget;
  final AxisDirection direction;

  SlidePageRoute({required this.widget, required this.direction})
      : super(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset.zero;
            var end = Offset.zero;
            switch (direction) {
              case AxisDirection.up:
                begin = Offset(0.0, 1.0);
                end = Offset.zero;
                break;
              case AxisDirection.right:
                begin = Offset(-1.0, 0.0);
                end = Offset.zero;
                break;
              case AxisDirection.down:
                begin = Offset(0.0, -1.0);
                end = Offset.zero;
                break;
              case AxisDirection.left:
                begin = Offset(1.0, 0.0);
                end = Offset.zero;
                break;
              default:
                break;
            }
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

class FadeInPageRoute extends PageRouteBuilder {
  final Widget widget;

  FadeInPageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class RipplePageRoute extends PageRouteBuilder {
  final Widget widget;

  RipplePageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: opacityAnimation,
              child: ScaleTransition(
                scale: animation,
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
        );
}

class FlipPageRoute extends PageRouteBuilder {
  final Widget widget;

  FlipPageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: ScaleTransition(
                scale: opacityAnimation,
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
        );
}

class ZoomPageRoute extends PageRouteBuilder {
  final Widget widget;

  ZoomPageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return ScaleTransition(
              scale: opacityAnimation,
              alignment: Alignment.center,
              child: child,
            );
          },
        );
}

class DiagonalPageRoute extends PageRouteBuilder {
  final Widget widget;

  DiagonalPageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class CurvePageRoute extends PageRouteBuilder {
  final Widget widget;

  CurvePageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              )),
              child: RotationTransition(
                turns: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.elasticInOut,
                )),
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutBack,
                  )),
                  child: child,
                ),
              ),
            );
          },
        );
}

class ParallaxPageRoute extends PageRouteBuilder {
  final Widget widget;

  ParallaxPageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
