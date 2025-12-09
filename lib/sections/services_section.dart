import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../utils/app_strings.dart';

class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;
  final String price;

  const ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
    required this.price,
  });
}

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    final primaryColor = Theme.of(context).primaryColor;

    final List<ServiceItem> services = [
      ServiceItem(
        title: strings.srvMobileTitle,
        description: strings.srvMobileDesc,
        icon: Icons.smartphone_rounded,
        features: strings.srvMobileFeatures,
        price: "\$500",
      ),
      ServiceItem(
        title: strings.srvWebTitle,
        description: strings.srvWebDesc,
        icon: Icons.language_rounded,
        features: strings.srvWebFeatures,
        price: "\$400",
      ),
      ServiceItem(
        title: strings.srvAiTitle,
        description: strings.srvAiDesc,
        icon: Icons.psychology_rounded,
        features: strings.srvAiFeatures,
        price: "\$800",
      ),
    ];

    return AnimatedBackground(
      type: BackgroundType.tech,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Column(
            children: [
              // Header
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                      ),
                    ),
                child: Column(
                  children: [
                    Text(
                      strings.txtAvailableModules,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.servicesTitle.toUpperCase(),
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Courier',
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor,
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64),

              // Grid Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 32,
                    runSpacing: 32,
                    alignment: WrapAlignment.center,
                    children: List.generate(services.length, (index) {
                      return AnimatedFadeSlide(
                        fade: CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            0.2 + (index * 0.1),
                            0.8 + (index * 0.1),
                            curve: Curves.easeOut,
                          ),
                        ),
                        slide:
                            Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  0.2 + (index * 0.1),
                                  0.8 + (index * 0.1),
                                  curve: Curves.easeOut,
                                ),
                              ),
                            ),
                        child: SizedBox(
                          width: isDesktop ? 350 : constraints.maxWidth,
                          child: _HolographicServiceCard(
                            service: services[index],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HolographicServiceCard extends StatefulWidget {
  final ServiceItem service;

  const _HolographicServiceCard({required this.service});

  @override
  State<_HolographicServiceCard> createState() =>
      _HolographicServiceCardState();
}

class _HolographicServiceCardState extends State<_HolographicServiceCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppStrings.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF050505).withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(4), // Tech corners
          border: Border.all(
            color: _isHovering
                ? primaryColor
                : primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    widget.service.icon,
                    size: 28,
                    color: primaryColor,
                  ),
                ),
                Text(
                  "${strings.txtModuleId}: ${widget.service.title.substring(0, 3).toUpperCase()}",
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 10,
                    color: primaryColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              widget.service.title.toUpperCase(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                color: theme.colorScheme.onSurface,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              widget.service.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(height: 24),

            // Features Divider
            Divider(color: primaryColor.withValues(alpha: 0.2)),
            const SizedBox(height: 16),

            // Features List
            ...widget.service.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.code, size: 14, color: primaryColor),
                    const SizedBox(width: 12),
                    Text(
                      feature.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Price & Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.startFrom.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      widget.service.price,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        shadows: [
                          Shadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final Uri whatsapp = Uri.parse(
                      'https://wa.me/6281234567890?text=${strings.msgWhatsapp} ${widget.service.title}',
                    );
                    if (!await launchUrl(whatsapp)) {
                      debugPrint('Could not launch $whatsapp');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    strings.btnOrder,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
