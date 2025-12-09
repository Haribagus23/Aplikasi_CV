import 'dart:math' as math;
import 'package:flutter/material.dart';

class TechSphere extends StatefulWidget {
  final List<String> tags;
  final double radius;
  final TextStyle textStyle;

  const TechSphere({
    super.key,
    required this.tags,
    this.radius = 150,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.white),
  });

  @override
  State<TechSphere> createState() => _TechSphereState();
}

class _TechSphereState extends State<TechSphere>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_TagPoint> _points;
  double _rotationX = 0;
  double _rotationY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _points = _generatePoints(widget.tags.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_TagPoint> _generatePoints(int count) {
    final points = <_TagPoint>[];
    final phi = math.pi * (3 - math.sqrt(5)); // Golden angle

    for (int i = 0; i < count; i++) {
      final y = 1 - (i / (count - 1)) * 2; // y goes from 1 to -1
      final radius = math.sqrt(1 - y * y); // radius at y

      final theta = phi * i; // golden angle increment

      final x = math.cos(theta) * radius;
      final z = math.sin(theta) * radius;

      points.add(_TagPoint(x, y, z, widget.tags[i]));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Auto rotation
        _rotationY += 0.005;
        _rotationX += 0.002;

        return CustomPaint(
          size: Size.square(widget.radius * 2),
          painter: _SpherePainter(
            points: _points,
            radius: widget.radius,
            rotationX: _rotationX,
            rotationY: _rotationY,
            textStyle: widget.textStyle,
            primaryColor: Theme.of(context).primaryColor,
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
          ),
        );
      },
    );
  }
}

class _TagPoint {
  double x, y, z;
  final String label;

  _TagPoint(this.x, this.y, this.z, this.label);
}

class _SpherePainter extends CustomPainter {
  final List<_TagPoint> points;
  final double radius;
  final double rotationX;
  final double rotationY;
  final TextStyle textStyle;
  final Color primaryColor;
  final bool isDarkMode;

  _SpherePainter({
    required this.points,
    required this.radius,
    required this.rotationX,
    required this.rotationY,
    required this.textStyle,
    required this.primaryColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Sort points by Z-depth so we draw the furthest ones first (painters algorithm)
    // We need to project them first to know their transformed Z
    final projectedPoints = points.map((p) {
      // Rotate around Y axis
      double x1 = p.x * math.cos(rotationY) - p.z * math.sin(rotationY);
      double z1 = p.z * math.cos(rotationY) + p.x * math.sin(rotationY);

      // Rotate around X axis
      double y1 = p.y * math.cos(rotationX) - z1 * math.sin(rotationX);
      double z2 = z1 * math.cos(rotationX) + p.y * math.sin(rotationX);

      return _ProjectedPoint(x1, y1, z2, p.label);
    }).toList();

    projectedPoints.sort((a, b) => a.z.compareTo(b.z));

    for (final p in projectedPoints) {
      // Calculate depth scale (0.5 to 1.0)
      // z2 goes from -1 (back) to 1 (front)
      final depth = (p.z + 1) / 2; // 0.0 to 1.0
      final scale = 0.6 + (depth * 0.4); // Scale factor
      final opacity = 0.3 + (depth * 0.7); // Opacity factor

      final x = center.dx + p.x * radius;
      final y = center.dy + p.y * radius;

      _drawTag(canvas, Offset(x, y), p.label, scale, opacity);
    }
  }

  void _drawTag(
    Canvas canvas,
    Offset position,
    String text,
    double scale,
    double opacity,
  ) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? 14) * scale,
        color: (isDarkMode ? Colors.white : Colors.black).withValues(
          alpha: opacity,
        ),
        fontWeight: FontWeight.bold,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Draw background pill
    final bgPaint = Paint()
      ..color = primaryColor.withValues(alpha: opacity * 0.15)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = primaryColor.withValues(alpha: opacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale;

    final padding = 8.0 * scale;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: position,
        width: textPainter.width + padding * 2,
        height: textPainter.height + padding,
      ),
      Radius.circular(12 * scale),
    );

    canvas.drawRRect(rect, bgPaint);
    canvas.drawRRect(rect, borderPaint);

    // Draw text
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SpherePainter oldDelegate) {
    return rotationX != oldDelegate.rotationX ||
        rotationY != oldDelegate.rotationY;
  }
}

class _ProjectedPoint {
  final double x, y, z;
  final String label;

  _ProjectedPoint(this.x, this.y, this.z, this.label);
}
