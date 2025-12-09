import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class LanguageLoadingOverlay extends StatefulWidget {
  const LanguageLoadingOverlay({super.key});

  @override
  State<LanguageLoadingOverlay> createState() => _LanguageLoadingOverlayState();
}

class _LanguageLoadingOverlayState extends State<LanguageLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final primaryColor = Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.85),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tech Spinner
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Text
                  Text(
                    "// ${strings.isIndonesian ? "TRANSLATING_SYSTEM" : "MENERJEMAHKAN_SISTEM"}...",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.isIndonesian ? "PLEASE WAIT..." : "MOHON TUNGGU...",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
