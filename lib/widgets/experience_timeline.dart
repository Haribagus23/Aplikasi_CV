import 'package:flutter/material.dart';

class ExperienceItem {
  final String year;
  final String title;
  final String company;
  final String description;
  final bool isEducation;

  const ExperienceItem({
    required this.year,
    required this.title,
    required this.company,
    required this.description,
    this.isEducation = false,
  });
}

class ExperienceTimeline extends StatelessWidget {
  final List<ExperienceItem> items;

  const ExperienceTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika lebar layar > 600, gunakan layout desktop (zig-zag)
        // Jika tidak, gunakan layout mobile (lurus)
        final isDesktop = constraints.maxWidth > 800;

        return Column(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isLeft = index % 2 == 0;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // KIRI (Desktop: Konten Genap, Mobile: Kosong)
                  if (isDesktop)
                    Expanded(
                      child: isLeft
                          ? _TimelineContent(item: item, isLeft: true)
                          : const SizedBox.shrink(),
                    ),

                  // TENGAH (Garis & Titik)
                  SizedBox(
                    width: 40,
                    child: Column(
                      children: [
                        // Garis Atas
                        Expanded(
                          child: Container(
                            width: 2,
                            color: index == 0
                                ? Colors.transparent
                                : Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        // Titik
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // Garis Bawah
                        Expanded(
                          child: Container(
                            width: 2,
                            color: index == items.length - 1
                                ? Colors.transparent
                                : Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // KANAN (Desktop: Konten Ganjil, Mobile: Semua Konten)
                  Expanded(
                    child: isDesktop
                        ? (isLeft
                              ? const SizedBox.shrink()
                              : _TimelineContent(item: item, isLeft: false))
                        : _TimelineContent(item: item, isLeft: false),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class _TimelineContent extends StatefulWidget {
  final ExperienceItem item;
  final bool isLeft;

  const _TimelineContent({required this.item, required this.isLeft});

  @override
  State<_TimelineContent> createState() => _TimelineContentState();
}

class _TimelineContentState extends State<_TimelineContent> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final align = widget.isLeft
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final textAlign = widget.isLeft ? TextAlign.right : TextAlign.left;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovering
                ? Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.08)
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovering
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.5)
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: align,
            children: [
              // Year Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.item.year,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                widget.item.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: textAlign,
              ),
              const SizedBox(height: 4),

              // Company / Institution
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.item.isEducation
                        ? Icons.school_outlined
                        : Icons.business_center_outlined,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.item.company,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                widget.item.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                textAlign: textAlign,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
