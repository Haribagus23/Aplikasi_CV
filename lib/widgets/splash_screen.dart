import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Durasi total splash
    )..repeat(); // Looping untuk background animation

    // Timer untuk mengakhiri splash screen
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: Matrix / Digital Particle Background
          Positioned.fill(
            child: CustomPaint(
              painter: _DigitalParticlePainter(animation: _controller),
            ),
          ),

          // LAYER 2: Glitch Logo Reveal
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Neon Circle Logo
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.cyanAccent.withValues(alpha: 0.8),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withValues(alpha: 0.4),
                              blurRadius: 20 * value,
                              spreadRadius: 5 * value,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "HB",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  offset: Offset(2 * (1 - value), 0),
                                  blurRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.redAccent,
                                  offset: Offset(-2 * (1 - value), 0),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Decoding Text Effect
                const _GlitchText(
                  text: "HARI BAGUS",
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    color: Colors.white,
                    fontFamily: 'Courier', // Monospace font for coding feel
                  ),
                ),
              ],
            ),
          ),

          // LAYER 3: Energy Scanner Line
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Scanner bergerak dari atas ke bawah berulang kali
              double scanValue = (_controller.value * 3) % 1.0;
              // * 3 agar lebih cepat dari durasi total

              return Positioned(
                top: MediaQuery.of(context).size.height * scanValue,
                left: 0,
                right: 0,
                child: Container(
                  height: 2, // Garis tipis
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.cyanAccent.withValues(alpha: 0.8),
                        Colors.white,
                        Colors.cyanAccent.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget untuk efek teks glitch/decoding
class _GlitchText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const _GlitchText({required this.text, required this.textStyle});

  @override
  State<_GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<_GlitchText> {
  String _displayText = "";
  final String _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()";
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startDecoding();
  }

  void _startDecoding() async {
    // Delay awal sebelum mulai decode
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i <= widget.text.length * 3; i++) {
      if (!mounted) return;

      setState(() {
        _displayText = List.generate(widget.text.length, (index) {
          if (index < i ~/ 3) {
            return widget.text[index];
          }
          return _chars[_random.nextInt(_chars.length)];
        }).join();
      });

      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Pastikan teks akhir benar
    if (mounted) {
      setState(() {
        _displayText = widget.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayText, style: widget.textStyle);
  }
}

// Painter untuk efek partikel digital
class _DigitalParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final Random _random = Random(42); // Fixed seed agar pola konsisten tapi acak

  _DigitalParticlePainter({required this.animation})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.3)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    // Gambar grid titik-titik bergerak
    final int cols = 10;
    final int rows = 20;
    final double cellWidth = size.width / cols;

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Buat efek "jatuh" seperti Matrix
        double offset =
            (animation.value * 2 * size.height) + (i * 50) + (j * 20);
        double y = offset % (size.height + 100) - 50;

        // Random opacity untuk efek kedip
        double opacity = (sin((animation.value * 10) + i + j) + 1) / 2 * 0.5;
        paint.color = Colors.cyanAccent.withValues(alpha: opacity);

        // Gambar karakter biner acak (0 atau 1) atau titik
        if (_random.nextBool()) {
          canvas.drawCircle(
            Offset(i * cellWidth + cellWidth / 2, y),
            1.5,
            paint,
          );
        } else {
          // Bisa diganti drawRect atau line untuk variasi
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(i * cellWidth + cellWidth / 2, y),
              width: 2,
              height: 6,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
