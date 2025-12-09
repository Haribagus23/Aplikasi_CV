import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../widgets/tilt_card.dart';
import '../utils/app_strings.dart';

// Enum for Project Categories
enum ProjectCategory { all, mobile, web, ai }

// Extended Model for Project
class ProjectModel {
  final String title;
  final String description;
  final String fullDescription; // Detailed description for modal
  final String imagePath;
  final String linkPlaceholder;
  final List<String> tech;
  final ProjectCategory category;

  ProjectModel({
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.imagePath,
    required this.linkPlaceholder,
    required this.tech,
    required this.category,
  });
}

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  ProjectCategory _selectedCategory = ProjectCategory.all;

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
    final strings = AppStrings.of(context);

    // Define projects list inside build to access context/strings
    final List<ProjectModel> projects = [
      ProjectModel(
        title: strings.proj1Title,
        description: strings.proj1Desc,
        fullDescription: strings.proj1FullDesc,
        imagePath: "assets/images/project5.jpeg",
        linkPlaceholder: "https://github.com/example/inventory",
        tech: ["Laravel", "Vue.js", "MySQL", "Bootstrap"],
        category: ProjectCategory.web,
      ),
      ProjectModel(
        title: strings.proj2Title,
        description: strings.proj2Desc,
        fullDescription: strings.proj2FullDesc,
        imagePath: "assets/images/HP.png",
        linkPlaceholder: "https://github.com/example/ecommerce-mobile",
        tech: ["Flutter", "Dart", "Firebase", "Stripe"],
        category: ProjectCategory.mobile,
      ),
      ProjectModel(
        title: strings.proj3Title,
        description: strings.proj3Desc,
        fullDescription: strings.proj3FullDesc,
        imagePath: "assets/images/project4.png",
        linkPlaceholder: "https://github.com/example/academic-portal",
        tech: ["PHP", "CodeIgniter", "jQuery", "MySQL"],
        category: ProjectCategory.web,
      ),
      ProjectModel(
        title: strings.proj4Title,
        description: strings.proj4Desc,
        fullDescription: strings.proj4FullDesc,
        imagePath: "assets/images/project2.jpg",
        linkPlaceholder: "https://github.com/example/secure-auth",
        tech: ["Flutter", "Bloc", "Biometrics", "OAuth 2.0"],
        category: ProjectCategory.mobile,
      ),
      ProjectModel(
        title: strings.proj5Title,
        description: strings.proj5Desc,
        fullDescription: strings.proj5FullDesc,
        imagePath: "assets/images/project3.png",
        linkPlaceholder: "https://github.com/example/frontend-arch",
        tech: ["React", "TypeScript", "Tailwind", "Vite"],
        category: ProjectCategory.web,
      ),
      ProjectModel(
        title: strings.proj6Title,
        description: strings.proj6Desc,
        fullDescription: strings.proj6FullDesc,
        imagePath: "assets/images/project6.jpg",
        linkPlaceholder: "https://github.com/example/java-erp",
        tech: ["Java", "Spring Boot", "PostgreSQL", "Docker"],
        category: ProjectCategory.ai, // Categorized as AI/Backend for variety
      ),
    ];

    // Filter projects
    final activeProjects = _selectedCategory == ProjectCategory.all
        ? projects
        : projects.where((p) => p.category == _selectedCategory).toList();
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
                  strings.projTitle,
                  style: textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Category Filter
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(
                          0.1,
                          0.6,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: ProjectCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    // Map category to string
                    String label;
                    switch (category) {
                      case ProjectCategory.all:
                        label = strings.catAll;
                        break;
                      case ProjectCategory.mobile:
                        label = strings.catMobile;
                        break;
                      case ProjectCategory.web:
                        label = strings.catWeb;
                        break;
                      case ProjectCategory.ai:
                        label = strings.catAi;
                        break;
                    }

                    return ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedCategory = category);
                        }
                      },
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.05),
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? (Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white)
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.1),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 48),

              // Grid List
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 1000 ? 3 : 1;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: GridView.builder(
                      key: ValueKey(_selectedCategory),
                      itemCount: activeProjects.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final double start = 0.2 + (index * 0.1);
                        final double end = start + 0.5;

                        return AnimatedFadeSlide(
                          fade: CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              start.clamp(0.0, 1.0),
                              end.clamp(0.0, 1.0),
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          slide:
                              Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Interval(
                                    start.clamp(0.0, 1.0),
                                    end.clamp(0.0, 1.0),
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                              ),
                          child: TiltCard(
                            child: ProjectCard(project: activeProjects[index]),
                          ),
                        );
                      },
                    ),
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

// Reusable Project Card Component with Hover Effects
class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovering = false;

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _ProjectDetailDialog(project: widget.project),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // strings variable removed as it was unused
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: _isHovering
              ? Matrix4.diagonal3Values(1.02, 1.02, 1.0)
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovering
                  ? primaryColor.withValues(alpha: 0.8)
                  : primaryColor.withValues(alpha: 0.1),
              width: _isHovering ? 2.0 : 1.0,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Holographic Grid Background (Subtle)
              if (_isHovering)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomPaint(
                      painter: _HolographicGridPainter(
                        color: primaryColor.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail with Tech Overlay
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.2),
                            ),
                            image: DecorationImage(
                              image: AssetImage(widget.project.imagePath),
                              fit: BoxFit.cover,
                              colorFilter: _isHovering
                                  ? null
                                  : ColorFilter.mode(
                                      Colors.black.withValues(alpha: 0.2),
                                      BlendMode.darken,
                                    ),
                            ),
                          ),
                        ),
                        // Corner Accents
                        Positioned(
                          top: 0,
                          left: 0,
                          child: _CornerAccent(color: primaryColor),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Transform.rotate(
                            angle: 3.14159,
                            child: _CornerAccent(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Title & Category
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.title.toUpperCase(),
                            style: textTheme.titleMedium?.copyWith(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              fontFamily: 'Courier', // Monospace for tech feel
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            widget.project.category.name.toUpperCase(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Expanded(
                      child: Text(
                        widget.project.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.black.withValues(alpha: 0.6),
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tech Stack (Chips)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.project.tech.take(3).map((tech) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : Colors.black.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            tech,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : Colors.black.withValues(alpha: 0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerAccent extends StatelessWidget {
  final Color color;

  const _CornerAccent({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _CornerPainter(color: color)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;

  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HolographicGridPainter extends CustomPainter {
  final Color color;

  _HolographicGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const double step = 20.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProjectDetailDialog extends StatelessWidget {
  final ProjectModel project;

  const _ProjectDetailDialog({required this.project});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F0);
    final borderColor = primaryColor.withValues(alpha: 0.3);
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 800;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: Container(
        width: isMobile ? double.infinity : 900,
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: primaryColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Grid
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: CustomPaint(
                  painter: _HolographicGridPainter(color: primaryColor),
                ),
              ),
            ),

            // Content
            Column(
              children: [
                // Header (Fixed at top)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                            ),
                            child: Text(
                              "ID: ${project.title.hashCode.toString().substring(0, 6).toUpperCase()}",
                              style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'Courier',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              project.title.toUpperCase(),
                              style: textTheme.headlineMedium?.copyWith(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier',
                                letterSpacing: 1.2,
                                fontSize: isMobile ? 20 : null,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close, color: primaryColor),
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(color: borderColor, thickness: 1),
                    ],
                  ),
                ),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        Expanded(
                          flex: isMobile ? 0 : 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: isMobile ? 200 : 250,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryColor.withValues(alpha: 0.5),
                                  ),
                                  color: Colors.black,
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      project.imagePath,
                                      fit: BoxFit.cover,
                                      opacity: const AlwaysStoppedAnimation(
                                        0.8,
                                      ),
                                    ),
                                    CustomPaint(
                                      painter: _ScanlinePainter(
                                        color: primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Text(
                                        "IMG_SOURCE_VERIFIED",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 10,
                                          fontFamily: 'Courier',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: project.tech.map((tech) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      border: Border.all(
                                        color: primaryColor.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tech.toUpperCase(),
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 11,
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        if (isMobile)
                          const SizedBox(height: 24)
                        else
                          const SizedBox(width: 32),

                        // Description Section
                        Expanded(
                          flex: isMobile ? 0 : 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "// SYSTEM_DESCRIPTION",
                                style: TextStyle(
                                  color: primaryColor.withValues(alpha: 0.7),
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                project.fullDescription,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.black.withValues(alpha: 0.8),
                                  height: 1.6,
                                  fontFamily: 'Courier',
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                "// ACCESS_LINK",
                                style: TextStyle(
                                  color: primaryColor.withValues(alpha: 0.7),
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                      project.linkPlaceholder,
                                    );
                                    if (!await launchUrl(url)) {
                                      debugPrint('Could not launch $url');
                                    }
                                  },
                                  icon: const Icon(Icons.terminal, size: 18),
                                  label: Text(
                                    "EXECUTE_PROTOCOL [OPEN]",
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: isDark
                                        ? Colors.black
                                        : Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

class _ScanlinePainter extends CustomPainter {
  final Color color;

  _ScanlinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
