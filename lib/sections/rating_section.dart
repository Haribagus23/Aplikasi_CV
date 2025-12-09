import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_fade_slide.dart';
import '../models/rating_model.dart';
import '../services/rating_service.dart';
import '../utils/app_strings.dart';

class RatingSection extends StatefulWidget {
  const RatingSection({super.key});

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  Future<List<Rating>>? _ratingsFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.forward();
    _refreshRatings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _refreshRatings() {
    setState(() {
      _ratingsFuture = RatingService.getRatings();
    });
  }

  void _showTransmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _TransmissionDialog(onSuccess: _refreshRatings),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final strings = AppStrings.of(context);

    return AnimatedBackground(
      type: BackgroundType.tech,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              // Title
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                      ),
                    ),
                child: Text(
                  strings.ratingTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
                      ),
                    ),
                child: Text(
                  strings.ratingSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'Courier',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 64),

              // Ratings Display
              FutureBuilder<List<Rating>>(
                future: _ratingsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      '${strings.ratingError}${snapshot.error}',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: Colors.redAccent,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      strings.ratingNoData,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    );
                  }

                  final reviews = snapshot.data!;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 800;

                      if (isMobile) {
                        // Mobile: Auto-scrolling Carousel
                        return SizedBox(
                          height: 320,
                          child: _ReviewCarousel(reviews: reviews),
                        );
                      } else {
                        // Desktop: Responsive Grid
                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          alignment: WrapAlignment.center,
                          children: List.generate(reviews.length, (index) {
                            return AnimatedFadeSlide(
                              fade: CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  0.2 + (index * 0.05).clamp(0.0, 0.5),
                                  0.8 + (index * 0.05).clamp(0.0, 0.2),
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
                                        0.2 + (index * 0.05).clamp(0.0, 0.5),
                                        0.8 + (index * 0.05).clamp(0.0, 0.2),
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                  ),
                              child: SizedBox(
                                width: 350, // Fixed width for desktop cards
                                child: _HolographicReviewCard(
                                  review: reviews[index],
                                ),
                              ),
                            );
                          }),
                        );
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 64),

              // Transmit Button
              AnimatedFadeSlide(
                fade: CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                ),
                slide:
                    Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _showTransmissionDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        border: Border.all(color: primaryColor, width: 2),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sensors, color: primaryColor),
                          const SizedBox(width: 16),
                          Text(
                            strings.btnInitiateTransmission,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCarousel extends StatefulWidget {
  final List<Rating> reviews;
  const _ReviewCarousel({required this.reviews});

  @override
  State<_ReviewCarousel> createState() => _ReviewCarouselState();
}

class _ReviewCarouselState extends State<_ReviewCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    // Auto-scroll logic could be added here if desired
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _HolographicReviewCard(review: widget.reviews[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.reviews.length > 10 ? 10 : widget.reviews.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 4,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HolographicReviewCard extends StatefulWidget {
  final Rating review;

  const _HolographicReviewCard({required this.review});

  @override
  State<_HolographicReviewCard> createState() => _HolographicReviewCardState();
}

class _HolographicReviewCardState extends State<_HolographicReviewCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF050505).withValues(alpha: 0.8)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8), // Tech corners
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
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: User ID & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  color: primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    "${strings.txtUsrPrefix}: ${widget.review.nama.toUpperCase()}",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                if (widget.review.createdAt != null)
                  Text(
                    widget.review.createdAt!.split('T')[0],
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 10,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Rating Bars
            Row(
              children: List.generate(5, (index) {
                final isActive = index < widget.review.rating;
                return Container(
                  width: 20,
                  height: 6,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? primaryColor
                        : primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Stack(
                children: [
                  Text(
                    widget.review.saran,
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 13,
                      height: 1.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Subtle Scanline Overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _ScanlinePainter(
                          color: primaryColor.withValues(alpha: 0.03),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer Status
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                strings.ratingStatusVerified,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  color: primaryColor.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransmissionDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  const _TransmissionDialog({required this.onSuccess});

  @override
  State<_TransmissionDialog> createState() => _TransmissionDialogState();
}

class _TransmissionDialogState extends State<_TransmissionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _suggestionController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  void _submit() async {
    final strings = AppStrings.of(context);
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() => _isSubmitting = true);

      final success = await RatingService.submitRating(
        nama: _nameController.text,
        rating: _rating,
        saran: _suggestionController.text,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
          Navigator.pop(context);
          widget.onSuccess();
          showDialog(
            context: context,
            builder: (context) => const _SuccessDialog(),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                strings.msgTransFailed,
                style: TextStyle(fontFamily: 'Courier'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final strings = AppStrings.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A).withValues(alpha: 0.95),
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.dialogTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'Courier',
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              _CyberTextField(
                controller: _nameController,
                label: strings.labelIdentifier,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Rating Selection
              Text(
                strings.labelSignalStrength,
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = index + 1),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 40,
                        height: 12,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: index < _rating
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: index < _rating
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Suggestion Field
              _CyberTextField(
                controller: _suggestionController,
                label: strings.labelDataPacket,
                icon: Icons.message_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      strings.btnAbort,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            strings.btnTransmit,
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CyberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const _CyberTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final strings = AppStrings.of(context);

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: 'Courier',
        color: theme.colorScheme.onSurface,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return strings.errFieldRequired;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Courier',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(icon, color: primaryColor.withValues(alpha: 0.7)),
        filled: true,
        fillColor: primaryColor.withValues(alpha: 0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.redAccent),
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
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double i = 0; i < size.height; i += 4) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppStrings.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A).withValues(alpha: 0.95),
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
                color: Colors.green.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              strings.txtSuccessTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Courier',
                fontWeight: FontWeight.bold,
                color: Colors.green,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              strings.txtSuccessMessage,
              style: TextStyle(
                fontFamily: 'Courier',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  strings.btnAcknowledge,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
