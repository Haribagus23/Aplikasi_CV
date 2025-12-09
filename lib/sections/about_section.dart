import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../widgets/infinite_marquee.dart';
import '../utils/app_strings.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  // Animations for each element
  late Animation<double> _fadeAvatar;
  late Animation<Offset> _slideAvatar;

  late Animation<double> _fadeName;
  late Animation<Offset> _slideName;

  late Animation<double> _fadeBio;
  late Animation<Offset> _slideBio;

  late Animation<double> _fadeSkills;
  late Animation<Offset> _slideSkills;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Helper to create staggered animations
    Animation<double> createFade(double start, double end) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );
    }

    Animation<Offset> createSlide(double start, double end) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    }

    // 1. Avatar (0.0 - 0.5)
    _fadeAvatar = createFade(0.0, 0.5);
    _slideAvatar = createSlide(0.0, 0.5);

    // 2. Name (0.1 - 0.6)
    _fadeName = createFade(0.1, 0.6);
    _slideName = createSlide(0.1, 0.6);

    // 3. Bio (0.2 - 0.7)
    _fadeBio = createFade(0.2, 0.7);
    _slideBio = createSlide(0.2, 0.7);

    // 4. Skills (0.3 - 0.8)
    _fadeSkills = createFade(0.3, 0.8);
    _slideSkills = createSlide(0.3, 0.8);

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBackground(
      type: BackgroundType.planet,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor.withValues(
          alpha: 0.5,
        ), // Semi-transparent to show planet
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return _buildDesktopLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final strings = AppStrings.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Avatar
          AnimatedFadeSlide(
            fade: _fadeAvatar,
            slide: _slideAvatar,
            child: _buildAvatar(context, 120),
          ),
          const SizedBox(height: 32),

          // 2. Name & Title
          AnimatedFadeSlide(
            fade: _fadeName,
            slide: _slideName,
            child: Column(
              children: [
                Text(
                  "Hari Bagus Setiawan",
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  strings.aboutRole,
                  style: textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Quick Stats
          AnimatedFadeSlide(
            fade: _fadeBio,
            slide: _slideBio,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildStatCard(context, Icons.code, "1+", strings.statYears),
                _buildStatCard(
                  context,
                  Icons.rocket_launch,
                  "5+",
                  strings.statProjects,
                ),
                _buildStatCard(context, Icons.coffee, "∞", strings.statCoffee),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 4. Bio
          AnimatedFadeSlide(
            fade: _fadeBio,
            slide: _slideBio,
            child: _buildBioCard(context),
          ),
          const SizedBox(height: 48),

          // 5. Skills
          AnimatedFadeSlide(
            fade: _fadeSkills,
            slide: _slideSkills,
            child: InfiniteMarquee(items: strings.marqueeSkills),
          ),
          const SizedBox(height: 80), // Bottom padding for nav bar
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final strings = AppStrings.of(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Avatar & Stats
            Expanded(
              flex: 4,
              child: Center(
                child: SingleChildScrollView(
                  child: AnimatedFadeSlide(
                    fade: _fadeAvatar,
                    slide: _slideAvatar,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAvatar(context, 200),
                        const SizedBox(height: 32),
                        Text(
                          "Hari Bagus Setiawan",
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.aboutRole,
                          style: textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatCard(
                              context,
                              Icons.code,
                              "1+",
                              strings.statYears,
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              context,
                              Icons.rocket_launch,
                              "5+",
                              strings.statProjects,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 64),

            // Right Column: Bio & Experience
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedFadeSlide(
                      fade: _fadeBio,
                      slide: _slideBio,
                      child: _buildBioCard(context),
                    ),
                    const SizedBox(height: 32),
                    AnimatedFadeSlide(
                      fade: _fadeSkills,
                      slide: _slideSkills,
                      child: InfiniteMarquee(items: strings.marqueeSkills),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/profile.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final strings = AppStrings.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.aboutTitle,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.aboutBio,
            style: textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.8,
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),
          // Quote
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 4,
                ),
              ),
            ),
            child: Text(
              strings.quoteText,
              style: textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
