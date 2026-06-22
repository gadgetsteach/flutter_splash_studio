import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that renders floating particles in the background.
class ParticleEngine extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color? particleColor;

  const ParticleEngine({
    super.key,
    required this.child,
    this.particleCount = 40,
    this.particleColor,
  });

  @override
  State<ParticleEngine> createState() => _ParticleEngineState();
}

class _ParticleEngineState extends State<ParticleEngine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particles = List.generate(widget.particleCount, (index) => _generateParticle());
  }

  _Particle _generateParticle() {
    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      speed: _random.nextDouble() * 0.5 + 0.2,
      radius: _random.nextDouble() * 3 + 1,
      angle: _random.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.particleColor ?? theme.colorScheme.primary.withValues(alpha: 0.4);

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _controller.value,
                  color: color,
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double speed;
  double radius;
  double angle;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.angle,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (var particle in particles) {
      // Update position based on progress and angle
      // progress goes from 0 to 1 repeatedly.
      // To make it smooth, we use time-based offset.
      double dx = particle.x * size.width + cos(particle.angle) * particle.speed * progress * size.width * 0.5;
      double dy = particle.y * size.height + sin(particle.angle) * particle.speed * progress * size.height * 0.5;

      // Wrap around edges
      dx = dx % size.width;
      dy = dy % size.height;
      if (dx < 0) dx += size.width;
      if (dy < 0) dy += size.height;

      canvas.drawCircle(Offset(dx, dy), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
