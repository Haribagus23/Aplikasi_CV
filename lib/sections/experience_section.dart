import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../widgets/experience_timeline.dart';
import '../utils/app_strings.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final textTheme = Theme.of(context).textTheme;
    final strings = AppStrings.of(context);

    // DATA PENGALAMAN (Bisa diedit sesuai kebutuhan)
    final experiences = [
      ExperienceItem(
        year: strings.expDate1,
        title: strings.expRole1,
        company: strings.expComp1,
        description: strings.expDesc1,
      ),
      ExperienceItem(
        year: strings.expDate2,
        title: strings.expRole2,
        company: strings.expComp2,
        description: strings.expDesc2,
      ),
      ExperienceItem(
        year: strings.expDate3,
        title: strings.expRole3,
        company: strings.expComp3,
        description: strings.expDesc3,
        isEducation: true,
      ),
      ExperienceItem(
        year: strings.expDate4,
        title: strings.expRole4,
        company: strings.expComp4,
        description: strings.expDesc4,
        isEducation: true,
      ),
    ];

    return AnimatedBackground(
      type: BackgroundType.space, // Space theme for "Journey"
      child: Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(
                          0.0,
                          0.5,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    ),
                child: Column(
                  children: [
                    Text(
                      strings.expTitle,
                      style: textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.expSubtitle,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),

              // Timeline
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(
                          0.2,
                          0.8,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    ),
                child: ExperienceTimeline(items: experiences),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
