import 'package:flutter/material.dart';
import '../models/splash_animation.dart';
import 'particle_engine.dart';
import 'ripple_animation.dart';

/// Routes the animation logic based on the requested [SplashAnimation].
class AnimationRouter extends StatelessWidget {
  final SplashAnimation animationType;
  final AnimationController controller;
  final Widget child;
  final Curve curve;

  const AnimationRouter({
    super.key,
    required this.animationType,
    required this.controller,
    required this.child,
    this.curve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(parent: controller, curve: curve);

    switch (animationType) {
      case SplashAnimation.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      case SplashAnimation.scale:
        return ScaleTransition(
          scale: curvedAnimation,
          child: child,
        );
      case SplashAnimation.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      case SplashAnimation.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      case SplashAnimation.zoomIn:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      case SplashAnimation.bounce:
        return ScaleTransition(
          scale: CurvedAnimation(parent: controller, curve: Curves.bounceOut),
          child: child,
        );
      case SplashAnimation.ripple:
        return RippleAnimation(
          controller: controller,
          child: child,
        );
      case SplashAnimation.particles:
        return ParticleEngine(
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        );
      // Fallback for unimplemented animations
      default:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
    }
  }
}
