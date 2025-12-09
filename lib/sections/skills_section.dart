import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../widgets/radar_chart.dart';
import '../utils/app_strings.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  String _selectedCategory = ""; // Will be set in build based on localized keys

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
    super.build(context);
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final strings = AppStrings.of(context);

    return AnimatedBackground(
      type: BackgroundType.tech,
      child: Container(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                child: Text(
                  strings.skillsTitle,
                  style: textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 64),

              // Layout: Desktop (Side by Side) vs Mobile (Column)
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCertifications(context)),
                    const SizedBox(width: 48),
                    Expanded(child: _buildSkillsRadar(context)),
                  ],
                )
              else
                Column(
                  children: [
                    _buildCertifications(context),
                    const SizedBox(height: 64),
                    _buildSkillsRadar(context),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertifications(BuildContext context) {
    final strings = AppStrings.of(context);
    final certs = strings.certifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          strings.tabCertifications,
          Icons.workspace_premium,
        ),
        const SizedBox(height: 32),
        ...certs.map((cert) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _CertificationCard(
              provider: cert['provider'] as String,
              courses: cert['courses'] as List<String>,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSkillsRadar(BuildContext context) {
    final strings = AppStrings.of(context);
    final primaryColor = Theme.of(context).primaryColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    // Data Skills
    final skillsData = strings.skillsData;

    // Ensure selected category is valid
    if (_selectedCategory.isEmpty ||
        !skillsData.containsKey(_selectedCategory)) {
      _selectedCategory = skillsData.keys.first;
    }

    final currentSkills = skillsData[_selectedCategory] ?? [];
    final values = currentSkills.map((s) => s['val'] as double).toList();
    final labels = currentSkills.map((s) => s['name'] as String).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSectionTitle(context, strings.tabSkills, Icons.code),
        const SizedBox(height: 32),

        // Category Selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: skillsData.keys.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : onSurface.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? primaryColor
                            : onSurface.withValues(alpha: 0.7),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 48),

        // Radar Chart Container
        SizedBox(
          height: 350,
          width: 350,
          child: TweenAnimationBuilder<double>(
            key: ValueKey(_selectedCategory), // Triggers animation on change
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: RadarChart(
                    values: values,
                    labels: labels,
                    color: primaryColor,
                    labelColor: onSurface,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centered title for better alignment
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _CertificationCard extends StatelessWidget {
  final String provider;
  final List<String> courses;

  const _CertificationCard({required this.provider, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...courses.map(
            (course) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      course,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
