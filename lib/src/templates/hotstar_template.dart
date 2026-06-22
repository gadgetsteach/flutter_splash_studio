import 'package:flutter/material.dart';
import '../models/splash_animation.dart';

/// Prebuilt Hotstar style splash screen template.
class HotstarTemplate {
  static const Color backgroundColor = Color(0xFF0F171E); // Dark blue/black
  static const SplashAnimation animation = SplashAnimation.fade;
  static const Duration duration = Duration(seconds: 3);
  
  static Widget buildLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Placeholder for Hotstar Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.play_arrow, color: Colors.white, size: 48),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Disney+ Hotstar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
