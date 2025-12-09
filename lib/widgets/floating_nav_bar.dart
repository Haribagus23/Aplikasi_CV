import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_strings.dart';

class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final bool isIndonesian;
  final VoidCallback onLanguageToggle;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.isIndonesian,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final strings = AppStrings.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final allNavItems = [
      _NavItem(0, Icons.home_rounded, strings.navHomeShort),
      _NavItem(1, Icons.person_rounded, strings.navAboutShort),
      _NavItem(2, Icons.school_rounded, strings.navSkillsShort),
      _NavItem(3, Icons.history_edu_rounded, strings.navExpShort),
      _NavItem(4, Icons.design_services_rounded, strings.navServShort),
      _NavItem(5, Icons.grid_view_rounded, strings.navProjShort),
      _NavItem(6, Icons.reviews_rounded, strings.navTestiShort),
      _NavItem(7, Icons.mail_rounded, strings.navContactShort),
    ];

    // On mobile, show only key sections to prevent overcrowding
    final visibleItems = isMobile
        ? allNavItems
              .where((item) => [0, 1, 5, 6, 7].contains(item.index))
              .toList()
        : allNavItems;

    final hiddenItems = isMobile
        ? allNavItems
              .where((item) => ![0, 1, 5, 6, 7].contains(item.index))
              .toList()
        : <_NavItem>[];

    return Positioned(
      bottom: 30,
      left: 16,
      right: 16,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF050505).withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decorative Top Line
                  Container(
                    height: 2,
                    width: 100,
                    margin: const EdgeInsets.only(bottom: 8, top: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          primaryColor,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Visible Nav Items
                          ...visibleItems.map((item) {
                            final isSelected = selectedIndex == item.index;
                            return _HudNavItem(
                              item: item,
                              isSelected: isSelected,
                              onTap: () => onItemSelected(item.index),
                              primaryColor: primaryColor,
                            );
                          }),

                          const SizedBox(width: 12),

                          // Vertical Divider
                          Container(
                            height: 24,
                            width: 1,
                            color: primaryColor.withValues(alpha: 0.3),
                          ),

                          const SizedBox(width: 12),

                          if (isMobile)
                            // Mobile: More Menu (Hidden Items + Settings)
                            _HudMoreMenu(
                              hiddenItems: hiddenItems,
                              selectedIndex: selectedIndex,
                              onItemSelected: onItemSelected,
                              onThemeToggle: onThemeToggle,
                              onLanguageToggle: onLanguageToggle,
                              isDarkMode: isDarkMode,
                              isIndonesian: isIndonesian,
                              primaryColor: primaryColor,
                              strings: strings,
                            )
                          else
                            // Desktop: Full Controls
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _HudIconButton(
                                  onTap: onThemeToggle,
                                  icon: isDarkMode
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                  tooltip: isDarkMode
                                      ? strings.navLightMode
                                      : strings.navDarkMode,
                                  primaryColor: primaryColor,
                                ),
                                const SizedBox(width: 8),
                                _HudTextButton(
                                  onTap: onLanguageToggle,
                                  text: isIndonesian ? "ID" : "EN",
                                  primaryColor: primaryColor,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Decorative Bottom Text
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      strings.navSystemReady,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 8,
                        color: primaryColor.withValues(alpha: 0.4),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HudNavItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;

  const _HudNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isSelected
                    ? primaryColor
                    : primaryColor.withValues(alpha: 0.5),
                size: 18,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HudIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String tooltip;
  final Color primaryColor;

  const _HudIconButton({
    required this.onTap,
    required this.icon,
    required this.tooltip,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
            color: primaryColor.withValues(alpha: 0.05),
          ),
          child: Icon(icon, size: 18, color: primaryColor),
        ),
      ),
    );
  }
}

class _HudTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color primaryColor;

  const _HudTextButton({
    required this.onTap,
    required this.text,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
          color: primaryColor.withValues(alpha: 0.05),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}

class _HudMoreMenu extends StatelessWidget {
  final List<_NavItem> hiddenItems;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onThemeToggle;
  final VoidCallback onLanguageToggle;
  final bool isDarkMode;
  final bool isIndonesian;
  final Color primaryColor;
  final AppStrings strings;

  const _HudMoreMenu({
    required this.hiddenItems,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onThemeToggle,
    required this.onLanguageToggle,
    required this.isDarkMode,
    required this.isIndonesian,
    required this.primaryColor,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: primaryColor),
      offset: const Offset(0, -200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: primaryColor, width: 1),
      ),
      color: const Color(0xFF0A0A0A).withValues(alpha: 0.95),
      onSelected: (value) {
        if (value == 'theme') {
          onThemeToggle();
        } else if (value == 'lang') {
          onLanguageToggle();
        } else if (value.startsWith('nav_')) {
          final index = int.parse(value.split('_')[1]);
          onItemSelected(index);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          // Hidden Navigation Items
          if (hiddenItems.isNotEmpty) ...[
            ...hiddenItems.map(
              (item) => PopupMenuItem<String>(
                value: 'nav_${item.index}',
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      color: selectedIndex == item.index
                          ? primaryColor
                          : primaryColor.withValues(alpha: 0.6),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        color: selectedIndex == item.index
                            ? primaryColor
                            : Colors.white,
                        fontWeight: selectedIndex == item.index
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const PopupMenuDivider(),
          ],

          // Settings
          PopupMenuItem<String>(
            value: 'theme',
            child: Row(
              children: [
                Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(
                  isDarkMode ? strings.navLightMode : strings.navDarkMode,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'lang',
            child: Row(
              children: [
                Icon(Icons.translate_rounded, color: primaryColor, size: 18),
                const SizedBox(width: 12),
                Text(
                  isIndonesian ? strings.navEnglish : strings.navIndonesian,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}

class _NavItem {
  final int index;
  final IconData icon;
  final String label;

  _NavItem(this.index, this.icon, this.label);
}
