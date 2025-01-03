import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
}

class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animation de fondu
            var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        );
}

class CustomAnimations {
  /// Animation pour une image
  static Widget animateImage(Widget child, int index) {
    return child
        .animate()
        .fadeIn(duration: 600.ms, delay: (index * 200).ms)
        .slide(begin: const Offset(0, 0.2));
  }

  /// Animation pour un élément de liste
  static Widget animateListTile(Widget child, int index) {
    return child
        .animate()
        .fadeIn(duration: 600.ms, delay: (index * 200).ms)
        .slide(begin: const Offset(0, 0.2));
  }
}
