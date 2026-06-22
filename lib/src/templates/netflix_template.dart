import 'package:flutter/material.dart';
import '../models/splash_animation.dart';

/// Prebuilt Netflix style splash screen template.
class NetflixTemplate {
  static const Color backgroundColor = Colors.black;
  static const SplashAnimation animation = SplashAnimation.zoomIn;
  static const Duration duration = Duration(seconds: 4);

  static Widget buildLogo() {
    return const Text(
      'NETFLIX',
      style: TextStyle(
        color: Color(0xFFE50914), // Netflix Red
        fontSize: 48,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
      ),
    );
  }
}
