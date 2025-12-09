import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/typewriter_text.dart';
import '../widgets/tech_sphere.dart';
import '../widgets/animated_background.dart';
import '../utils/app_strings.dart';

class GetStartedSection extends StatefulWidget {
  final VoidCallback? onScrollRequested;

  const GetStartedSection({super.key, this.onScrollRequested});

  @override
  State<GetStartedSection> createState() => _GetStartedSectionState();
}

class _GetStartedSectionState extends State<GetStartedSection>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Controllers
  late AnimationController _entranceController;
  late AnimationController _scrollIndicatorController;

  @override
  bool get wantKeepAlive => true;

  // Animations
  late Animation<double> _fadeTitle;
  late Animation<Offset> _slideTitle;
  late Animation<double> _fadeSubtitle;
  late Animation<Offset> _slideSubtitle;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Animation Setup
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _slideTitle = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _fadeSubtitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _slideSubtitle =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // 2. Scroll Indicator Animation (Looping Bounce)
    _scrollIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Start Entrance
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _scrollIndicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final strings = AppStrings.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F2C),
      body: AnimatedBackground(
        type: BackgroundType.space,
        child: Stack(
          children: [
            // LAYER 1: Background Gradient (Subtle Overlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [
                            const Color(0xFF1A1F2C).withValues(alpha: 0.8),
                            const Color(0xFF2D3447).withValues(alpha: 0.8),
                          ]
                        : [
                            const Color(0xFFF5F7FA).withValues(alpha: 0.8),
                            const Color(0xFFE4E7EB).withValues(alpha: 0.8),
                          ],
                  ),
                ),
              ),
            ),

            // LAYER 2: Main Content
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 80),

                            // Hero Title
                            SlideTransition(
                              position: _slideTitle,
                              child: FadeTransition(
                                opacity: _fadeTitle,
                                child: Text(
                                  strings.hello,
                                  style: textTheme.displayLarge?.copyWith(
                                    fontSize: 72,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    height: 1.1,
                                    letterSpacing: -1.5,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Subheadline
                            SlideTransition(
                              position: _slideSubtitle,
                              child: FadeTransition(
                                opacity: _fadeSubtitle,
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      strings.iBuild,
                                      style: textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    TypewriterText(
                                      texts: [
                                        strings.typeMobile,
                                        strings.typeWeb,
                                        strings.typeExp,
                                      ],
                                      style: textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Download CV Button
                            SlideTransition(
                              position: _slideSubtitle,
                              child: FadeTransition(
                                opacity: _fadeSubtitle,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                      'https://example.com/cv.pdf',
                                    );
                                    if (!await launchUrl(url)) {
                                      debugPrint('Could not launch $url');
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    size: 20,
                                  ),
                                  label: Text(strings.downloadCv),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.3),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Tech Sphere
                            FadeTransition(
                              opacity: _fadeSubtitle,
                              child: Center(
                                child: SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: TechSphere(
                                    tags: const [
                                      "Flutter",
                                      "Dart",
                                      "Firebase",
                                      "React",
                                      "AI",
                                      "Python",
                                      "UI/UX",
                                      "Git",
                                      "Mobile",
                                      "Web",
                                      "AWS",
                                      "SQL",
                                      "Laravel",
                                      "Node.js",
                                    ],
                                    radius: 140,
                                    textStyle:
                                        textTheme.bodyMedium ??
                                        const TextStyle(),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 80),

                            // Scroll Indicator
                            Center(
                              child: InkWell(
                                onTap: widget.onScrollRequested,
                                borderRadius: BorderRadius.circular(30),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        strings.scrollExplore,
                                        style: textTheme.labelSmall?.copyWith(
                                          color: Colors.white38,
                                          letterSpacing: 3,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      AnimatedBuilder(
                                        animation: _scrollIndicatorController,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(
                                              0,
                                              6 *
                                                  math.sin(
                                                    _scrollIndicatorController
                                                            .value *
                                                        math.pi,
                                                  ),
                                            ),
                                            child: Opacity(
                                              opacity:
                                                  0.5 +
                                                  (0.5 *
                                                      math.sin(
                                                        _scrollIndicatorController
                                                                .value *
                                                            math.pi,
                                                      )),
                                              child: child,
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
