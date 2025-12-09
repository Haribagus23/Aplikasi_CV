import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration holdDuration;

  const TypewriterText({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.deletingSpeed = const Duration(milliseconds: 50),
    this.holdDuration = const Duration(seconds: 2),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _currentText = "";
  int _currentIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer = Timer.periodic(
      _isDeleting ? widget.deletingSpeed : widget.typingSpeed,
      (timer) {
        final currentFullText = widget.texts[_currentIndex];

        if (_isDeleting) {
          if (_charIndex > 0) {
            setState(() {
              _charIndex--;
              _currentText = currentFullText.substring(0, _charIndex);
            });
          } else {
            _isDeleting = false;
            _currentIndex = (_currentIndex + 1) % widget.texts.length;
            _timer?.cancel();
            _startTyping();
          }
        } else {
          if (_charIndex < currentFullText.length) {
            setState(() {
              _charIndex++;
              _currentText = currentFullText.substring(0, _charIndex);
            });
          } else {
            _isDeleting = true;
            _timer?.cancel();
            Future.delayed(widget.holdDuration, _startTyping);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_currentText, style: widget.style),
        _CursorBlink(style: widget.style),
      ],
    );
  }
}

class _CursorBlink extends StatefulWidget {
  final TextStyle? style;
  const _CursorBlink({this.style});

  @override
  State<_CursorBlink> createState() => _CursorBlinkState();
}

class _CursorBlinkState extends State<_CursorBlink>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        "|",
        style: widget.style?.copyWith(fontWeight: FontWeight.w200),
      ),
    );
  }
}
