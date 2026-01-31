import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:photomall_flutter/color_constants.dart';
import 'package:photomall_flutter/core/constants/common_constants.dart';

class CustomItemTransition extends StatelessWidget {
  final Widget child;
  final int delay;
  final int duration;
  final int? type;

  CustomItemTransition(
      {Key? key,
      required this.delay,
      required this.duration,
      this.type,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getTransition(
      child: child,
    );
  }

  Widget getTransition({required Widget child}) {
    switch (AppColorData.itemTransition) {
      case 1:
        {
          return FadeInRight(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 2:
        {
          return FadeIn(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 3:
        {
          return FadeInDown(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 4:
        {
          return FadeInDownBig(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 5:
        {
          return FadeInUp(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 6:
        {
          return FadeInUpBig(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 7:
        {
          return FadeInLeft(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 8:
        {
          return FadeInLeftBig(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      case 9:
        {
          return FadeInRightBig(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );
        }
      default:
        {
          return FadeIn(
            delay: Duration(milliseconds: delay),
            duration: Duration(milliseconds: duration),
            child: child,
          );

          /*
          return FadeInRight(
            delay: Duration(milliseconds: 0),
            duration: Duration(milliseconds: 0),
            child: child,
          );
        */
        }
    }
  }
}

//int pageTransitionValue = 1;

class CustomPageTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final int? returnValue;

  CustomPageTransitionRoute({
    required this.page,
    this.returnValue,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: Duration(milliseconds: pageTransitionDuration),
          reverseTransitionDuration:
              Duration(milliseconds: pageReversTransitionDuration),
          barrierColor: Colors.transparent,
          barrierDismissible: true,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            switch (AppColorData.pageTransition) {
              case 1:
                {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }
              case 2:
                {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                }
              case 3:
                {
                  return ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                    child: child,
                  );
                }
              case 4:
                {
                  return RotationTransition(
                    turns: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.linear,
                      ),
                    ),
                    child: child,
                  );
                }
              case 5:
                {
                  return Align(
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                }
              case 6:
                {
                  return ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                    child: RotationTransition(
                      turns: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.linear,
                        ),
                      ),
                      child: child,
                    ),
                  );
                }
              default:
                {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }
            }
          },
        );
}
