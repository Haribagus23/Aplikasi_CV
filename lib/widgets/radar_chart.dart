import 'dart:math';
import 'package:flutter/material.dart';

class RadarChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color color;
  final Color labelColor;

  const RadarChart({
    super.key,
    required this.values,
    required this.labels,
    this.maxValue = 1.0,
    this.color = Colors.cyanAccent,
    this.labelColor = Colors.white,
  });

  @override
  State<RadarChart> createState() => _RadarChartState();
}

class _RadarChartState extends State<RadarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _RadarChartPainter(
            values: widget.values,
            labels: widget.labels,
            maxValue: widget.maxValue,
            color: widget.color,
            labelColor: widget.labelColor,
            scanValue: _scanController.value,
          ),
        );
      },
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final double maxValue;
  final Color color;
  final Color labelColor;
  final double scanValue;

  _RadarChartPainter({
    required this.values,
    required this.labels,
    required this.maxValue,
    required this.color,
    required this.labelColor,
    required this.scanValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 0.75;

    final paintStroke = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.05)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw Background Grid (Concentric Polygons)
    for (int i = 1; i <= 4; i++) {
      double r = radius * (i / 4);
      _drawPolygon(canvas, center, r, values.length, gridPaint);
    }

    // Draw Axis Lines
    final angleStep = (2 * pi) / values.length;
    for (int i = 0; i < values.length; i++) {
      final angle = -pi / 2 + (i * angleStep);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    // Draw Data Polygon
    final path = Path();
    final nodePoints = <Offset>[];

    for (int i = 0; i < values.length; i++) {
      final value = (values[i] / maxValue).clamp(0.0, 1.0);
      final r = radius * value;
      final angle = -pi / 2 + (i * angleStep);
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      nodePoints.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Draw Fill & Stroke
    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintStroke);

    // Draw Glowing Nodes
    for (final point in nodePoints) {
      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(point, 3, Paint()..color = Colors.white);
    }

    // Draw Rotating Scan Line (Radar Effect)
    final scanAngle = -pi / 2 + (scanValue * 2 * pi);

    final scanPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: scanAngle - 0.5,
        endAngle: scanAngle,
        colors: [color.withValues(alpha: 0.0), color.withValues(alpha: 0.3)],
        stops: const [0.0, 1.0],
        transform: GradientRotation(scanAngle), // Rotate gradient correctly
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Draw sector scan
    canvas.drawCircle(center, radius, scanPaint);

    // Draw Labels
    _drawLabels(canvas, center, radius, angleStep);
  }

  void _drawPolygon(
    Canvas canvas,
    Offset center,
    double radius,
    int sides,
    Paint paint,
  ) {
    final path = Path();
    final angleStep = (2 * pi) / sides;

    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + (i * angleStep);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double angleStep,
  ) {
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < labels.length; i++) {
      final angle = -pi / 2 + (i * angleStep);
      // Add extra padding for labels based on angle to avoid overlap
      final labelRadius = radius + 25;
      final x = center.dx + labelRadius * cos(angle);
      final y = center.dy + labelRadius * sin(angle);

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: labelColor.withValues(alpha: 0.8),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
          shadows: [Shadow(color: color.withValues(alpha: 0.5), blurRadius: 4)],
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.scanValue != scanValue ||
        oldDelegate.values != values ||
        oldDelegate.color != color;
  }
}
