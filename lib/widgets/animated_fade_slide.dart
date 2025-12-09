import 'package:flutter/material.dart';

/// A reusable widget that applies a staggered Fade and Slide animation.
/// Useful for entrance animations of list items or section content.
class AnimatedFadeSlide extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;

  const AnimatedFadeSlide({
    super.key,
    required this.fade,
    required this.slide,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
