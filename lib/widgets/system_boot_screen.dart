import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class SystemBootScreen extends StatefulWidget {
  final VoidCallback onBootComplete;

  const SystemBootScreen({super.key, required this.onBootComplete});

  @override
  State<SystemBootScreen> createState() => _SystemBootScreenState();
}

class _SystemBootScreenState extends State<SystemBootScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _logs = [];
  double _progress = 0.0;
  bool _isBootComplete = false;
  bool _isExiting = false; // State untuk animasi keluar

  // Daftar log yang akan ditampilkan satu per satu
  bool _bootStarted = false;
  late List<String> _fullLogs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bootStarted) {
      _bootStarted = true;
      final strings = AppStrings.of(context);
      _fullLogs = [
        strings.bootInitKernel,
        strings.bootLoadModules,
        strings.bootCpuOk,
        strings.bootMemOk,
        strings.bootNetSecure,
        strings.bootDecryptProfile,
        strings.bootFetchSkills,
        strings.bootFlutterDetected,
        strings.bootDartDetected,
        strings.bootFirebaseConnected,
        strings.bootCalibrateUi,
        strings.bootLoadAssets,
        strings.bootWarnCreativity,
        strings.bootSystemReady,
        strings.bootWaitInput,
      ];
      _startBootSequence();
    }
  }

  @override
  void initState() {
    super.initState();
    // Boot sequence started in didChangeDependencies to access context
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startBootSequence() async {
    int processedLogs = 0;
    for (String log in _fullLogs) {
      if (!mounted) return;

      // Simulasi ketikan per baris
      await Future.delayed(Duration(milliseconds: 50 + (log.length * 5)));

      setState(() {
        _logs.add(log);
        processedLogs++;
        _progress = processedLogs / _fullLogs.length;
      });

      // Auto scroll ke bawah
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }

    if (mounted) {
      setState(() {
        _isBootComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Grid Pattern
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Terminal
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        strings.bootHeader,
                        style: TextStyle(
                          color: Colors.cyanAccent.withValues(alpha: 0.5),
                          fontFamily: 'Courier',
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Area Log (Task 2: Hacker Typing Effect)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.cyanAccent.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        color: Colors.cyanAccent.withValues(alpha: 0.05),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              _logs[index],
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontFamily: 'Courier',
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Area Bawah (Task 3: Cyber Progress Bar)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings.bootSystemStatus,
                            style: TextStyle(
                              color: Colors.cyanAccent.withValues(alpha: 0.7),
                              fontFamily: 'Courier',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${(_progress * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontFamily: 'Courier',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Custom Segmented Progress Bar
                      SizedBox(
                        height: 10,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final int totalSegments = 20;
                            final double segmentWidth =
                                (constraints.maxWidth -
                                    (totalSegments - 1) * 2) /
                                totalSegments;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(totalSegments, (index) {
                                final double threshold =
                                    (index + 1) / totalSegments;
                                final bool isActive = _progress >= threshold;

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: segmentWidth,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.cyanAccent
                                        : Colors.cyanAccent.withValues(
                                            alpha: 0.1,
                                          ),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: Colors.cyanAccent
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : [],
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Task 5: Access Granted Button
                  if (_isBootComplete)
                    Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isExiting = true;
                            });
                            await Future.delayed(
                              const Duration(milliseconds: 800),
                            );
                            widget.onBootComplete();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent.withValues(alpha: 0.1),
                              border: Border.all(
                                color: Colors.cyanAccent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lock_open,
                                  color: Colors.cyanAccent,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  strings.bootAccessGranted,
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontFamily: 'Courier',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.cyanAccent.withValues(
                                          alpha: 0.8,
                                        ),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // HUD Decoration: Top Right Corner
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: _isExiting ? -100 : 50,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 1,
                  color: Colors.cyanAccent.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.bootSecureConn,
                  style: TextStyle(
                    color: Colors.cyanAccent.withValues(alpha: 0.3),
                    fontFamily: 'Courier',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // HUD Decoration: Bottom Left Corner
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: _isExiting ? -100 : 40,
            left: 20,
            child: Row(
              children: [
                Icon(
                  Icons.memory,
                  color: Colors.cyanAccent.withValues(alpha: 0.3),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  strings.bootMemUsage,
                  style: TextStyle(
                    color: Colors.cyanAccent.withValues(alpha: 0.3),
                    fontFamily: 'Courier',
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // CRT Turn Off Effect Overlay
          if (_isExiting)
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Container(
                    color: Colors.black.withValues(alpha: value),
                    child: Center(
                      child: Container(
                        height: 2 * (1 - value),
                        width: MediaQuery.of(context).size.width * (1 - value),
                        color: Colors.cyanAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const double gridSize = 40;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
