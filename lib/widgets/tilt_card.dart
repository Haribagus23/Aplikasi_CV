import 'package:flutter/material.dart';

class TiltCard extends StatefulWidget {
  final Widget child;
  final double sensitivity;
  final double maxTilt;

  const TiltCard({
    super.key,
    required this.child,
    this.sensitivity = 0.001, // Sensitivity of the tilt
    this.maxTilt = 0.1, // Max tilt angle in radians
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  Alignment _dragAlignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _alignmentAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent details) {
    final size = context.size!;
    final localPosition = details.localPosition;

    // Convert local position to alignment (-1.0 to 1.0)
    final x = (localPosition.dx / size.width) * 2 - 1;
    final y = (localPosition.dy / size.height) * 2 - 1;

    setState(() {
      _dragAlignment = Alignment(x, y);
    });
  }

  void _onExit(PointerEvent details) {
    _runResetAnimation();
  }

  void _runResetAnimation() {
    _alignmentAnimation = _controller.drive(
      AlignmentTween(begin: _dragAlignment, end: Alignment.center),
    );
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, widget.sensitivity) // Perspective
          ..rotateX(-_dragAlignment.y * widget.maxTilt)
          ..rotateY(_dragAlignment.x * widget.maxTilt),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
