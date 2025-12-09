import 'dart:math';
import 'package:flutter/material.dart';

enum BackgroundType {
  space, // Particles/Stars
  planet, // Glowing Planet/Orb
  tech, // Grid/Network lines
  gradient, // Simple animated gradient
}

class AnimatedBackground extends StatefulWidget {
  final BackgroundType type;
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.type,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles based on type
    if (widget.type == BackgroundType.space) {
      for (int i = 0; i < 50; i++) {
        _particles.add(_generateParticle());
      }
    }
  }

  _Particle _generateParticle() {
    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 3 + 1,
      speed: _random.nextDouble() * 0.2 + 0.05,
      opacity: _random.nextDouble() * 0.5 + 0.1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Layer
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _BackgroundPainter(
                  type: widget.type,
                  animationValue: _controller.value,
                  particles: _particles,
                  colorScheme: Theme.of(context).colorScheme,
                ),
              );
            },
          ),
        ),
        // Content Layer
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _BackgroundPainter extends CustomPainter {
  final BackgroundType type;
  final double animationValue;
  final List<_Particle> particles;
  final ColorScheme colorScheme;

  _BackgroundPainter({
    required this.type,
    required this.animationValue,
    required this.particles,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case BackgroundType.space:
        _paintSpace(canvas, size);
        break;
      case BackgroundType.planet:
        _paintPlanet(canvas, size);
        break;
      case BackgroundType.tech:
        _paintTech(canvas, size);
        break;
      case BackgroundType.gradient:
        // Just a simple gradient, handled by container usually, but can add noise here
        break;
    }
  }

  void _paintSpace(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      // Update position (move up slowly)
      double currentY = (particle.y - (animationValue * particle.speed)) % 1.0;
      if (currentY < 0) currentY += 1.0;

      final position = Offset(particle.x * size.width, currentY * size.height);

      paint.color = colorScheme.primary.withValues(alpha: particle.opacity);
      canvas.drawCircle(position, particle.size, paint);
    }
  }

  void _paintPlanet(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.85, size.height * 0.25);
    final radius = size.width * 0.25;

    // 1. Outer Glow (Atmosphere)
    final glowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60)
      ..color = colorScheme.primary.withValues(alpha: 0.3);
    canvas.drawCircle(center, radius + 40, glowPaint);

    // 2. Planet Body
    final planetPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          colorScheme.primaryContainer,
          colorScheme.primary.withValues(alpha: 0.6),
          Colors.black.withValues(alpha: 0.9),
        ],
        stops: const [0.1, 0.6, 1.0],
        center: const Alignment(-0.5, -0.5),
        radius: 1.4,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, planetPaint);

    // 3. Rings
    final ringRect = Rect.fromCenter(
      center: center,
      width: radius * 3.2,
      height: radius * 0.6,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi / 6); // Tilt 30 degrees
    canvas.translate(-center.dx, -center.dy);

    // Ring Gradient
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.1
      ..shader = SweepGradient(
        colors: [
          colorScheme.primary.withValues(alpha: 0.1),
          colorScheme.secondary.withValues(alpha: 0.4),
          colorScheme.primary.withValues(alpha: 0.1),
        ],
      ).createShader(ringRect);

    canvas.drawOval(ringRect, ringPaint);

    // Thin detail line
    final ringDetailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = colorScheme.onSurface.withValues(alpha: 0.3);
    canvas.drawOval(ringRect.deflate(10), ringDetailPaint);

    canvas.restore();
  }

  void _paintTech(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.primary
          .withValues(alpha: 0.15) // Increased visibility
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw a moving grid
    double gridSize = 60.0;
    double offset = animationValue * gridSize;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal moving lines
    for (double y = offset % gridSize; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw "Nodes" at intersections
    final nodePaint = Paint()
      ..color = colorScheme.secondary.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = offset % gridSize; y < size.height; y += gridSize) {
        // Only draw some nodes randomly to look like data flow
        if ((x + y).toInt() % 3 == 0) {
          canvas.drawCircle(Offset(x, y), 2.5, nodePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
