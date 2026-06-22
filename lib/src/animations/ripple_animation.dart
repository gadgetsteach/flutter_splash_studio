import 'package:flutter/material.dart';

/// A widget that renders a ripple effect originating from the center.
class RippleAnimation extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final Color? rippleColor;

  const RippleAnimation({
    super.key,
    required this.child,
    required this.controller,
    this.rippleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = rippleColor ?? theme.colorScheme.primary.withValues(alpha: 0.3);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, childWidget) {
        return CustomPaint(
          painter: _RipplePainter(
            progress: controller.value,
            color: color,
          ),
          child: childWidget,
        );
      },
      child: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: controller, curve: Curves.easeIn),
          child: child,
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width > size.height ? size.width : size.height;

    final paint = Paint()
      ..color = color.withValues(alpha: (1.0 - progress).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, maxRadius * progress, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
