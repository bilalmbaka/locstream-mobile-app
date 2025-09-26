import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/routes.dart';

enum PageTransitionStyle {
  fade,
  scale,
  size,
  rotate,
  bottomToTop,
  topToBottom,
  leftToRight,
  rightToLeft,
}

class NavigationService<T extends Object?> {
  static Future<T?> pushToScreen<T>({
    required BuildContext context,
    required String routeName,
    Map<String, String> queryParams = const {},
    T? data,
  }) async {
    return await context.pushNamed<T>(
      routeName,
      extra: data,
      queryParameters: queryParams,
    );
  }

  static jumpToScreen({
    required BuildContext context,
    required String routeName,
    Map<String, String> queryParams = const {},
    dynamic data,
  }) {
    context.goNamed(routeName, extra: data, queryParameters: queryParams);
  }

  static replaceTopScreen({
    required BuildContext context,
    required String routeName,
    Map<String, String> queryParams = const {},
    dynamic data,
  }) {
    context.pushReplacementNamed(routeName,
        extra: data, queryParameters: queryParams);
  }

  static popScreenUntil<T>({
    required String routeName,
    T? data,
  }) {
    final topScreen =
        routes.routerDelegate.currentConfiguration.matches.last.matchedLocation;

    while (topScreen != routeName) {
      if (!routes.canPop()) {
        return;
      }

      routes.pop<T>(data);
    }
  }

  static pop<T>({
    required BuildContext context,
    T? data,
  }) {
    context.pop<T?>(data);
  }
}

class PageTransitionAnimationHelper {
  ///Helper function to animate the page transition for go_router
  static CustomTransitionPage animateGoRoutePageTransition({
    required GoRouterState state,
    required Widget child,
    Offset? begin = Offset.zero,
    Offset? end = Offset.zero,
    int? forwardDuration,
    PageTransitionStyle? type,
  }) {
    return CustomTransitionPage(
        transitionDuration: Duration(milliseconds: forwardDuration ?? 500),
        reverseTransitionDuration:
            Duration(milliseconds: forwardDuration ?? 500),
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (type == null) {
            return child;
          } else {
            switch (type) {
              case PageTransitionStyle.fade:
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
                  child: child,
                );
              case PageTransitionStyle.scale:
                // TODO: Handle this case.
                throw UnimplementedError();
              case PageTransitionStyle.size:
                // TODO: Handle this case.
                throw UnimplementedError();
              case PageTransitionStyle.rotate:
                // TODO: Handle this case.
                throw UnimplementedError();
              case PageTransitionStyle.bottomToTop:
                return slideTransition(
                  child: child,
                  begin: Offset(0.0, -1.0),
                  end: Offset.zero,
                  animation: animation,
                );
              case PageTransitionStyle.topToBottom:
                return slideTransition(
                  child: child,
                  begin: Offset(0.0, 1.0),
                  end: Offset.zero,
                  animation: animation,
                );
              case PageTransitionStyle.leftToRight:
                return slideTransition(
                  child: child,
                  begin: Offset(-1.0, 0.0),
                  end: Offset.zero,
                  animation: animation,
                );
              case PageTransitionStyle.rightToLeft:
                return slideTransition(
                  child: child,
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                  animation: animation,
                );
            }
          }
        });
  }

  static SlideTransition slideTransition(
      {required Widget child,
      required Offset begin,
      required Offset end,
      required Animation<double> animation}) {
    var tween = Tween(begin: begin, end: end);
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
