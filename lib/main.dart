import 'package:flutter/material.dart';
import 'core/theme_provider.dart';
import 'sections/get_started_section.dart';
import 'sections/about_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'sections/experience_section.dart';
import 'sections/services_section.dart';
import 'sections/rating_section.dart';
import 'sections/contact_section.dart';
import 'widgets/floating_nav_bar.dart';
import 'widgets/splash_screen.dart';
import 'widgets/welcome_dialog.dart';
import 'widgets/system_boot_screen.dart';
import 'widgets/language_loading_overlay.dart';
import 'utils/language_provider.dart';
import 'services/onesignal_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OneSignal
  OneSignalService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();
  final LanguageProvider _languageProvider = LanguageProvider();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_themeProvider, _languageProvider]),
      builder: (context, child) {
        return LanguageScope(
          notifier: _languageProvider,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Hari Portfolio',
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: _themeProvider.themeMode,
            home: RootView(
              themeProvider: _themeProvider,
              languageProvider: _languageProvider,
            ),
          ),
        );
      },
    );
  }
}

class RootView extends StatefulWidget {
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;

  const RootView({
    super.key,
    required this.themeProvider,
    required this.languageProvider,
  });

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  bool _showSplash = true;
  bool _showBoot = false;
  bool _isLanguageLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavSelected(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutQuart,
    );
  }

  void _handleLanguageToggle() async {
    setState(() {
      _isLanguageLoading = true;
    });

    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 1500));

    // Toggle Language
    widget.languageProvider.toggleLanguage();

    // Small delay to let the UI rebuild with new language before removing overlay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLanguageLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          PageView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            children: [
              GetStartedSection(onScrollRequested: () => _onNavSelected(1)),
              const AboutSection(),
              const SkillsSection(),
              const ExperienceSection(),
              const ServicesSection(),
              const ProjectsSection(),
              const RatingSection(),
              const ContactSection(),
            ],
          ),

          // Floating Navigation Bar (Overlay)
          if (!_showSplash && !_showBoot && !_isLanguageLoading)
            FloatingNavBar(
              selectedIndex: _currentIndex,
              onItemSelected: _onNavSelected,
              isDarkMode: widget.themeProvider.isDarkMode,
              onThemeToggle: widget.themeProvider.toggleTheme,
              isIndonesian: widget.languageProvider.isIndonesian,
              onLanguageToggle: _handleLanguageToggle,
            ),

          // Boot Screen Overlay
          if (_showBoot)
            Positioned.fill(
              child: SystemBootScreen(
                onBootComplete: () {
                  setState(() {
                    _showBoot = false;
                  });
                  // Show Welcome Dialog after boot finishes
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (!context.mounted) return;
                    WelcomeDialog.show(context);
                  });
                },
              ),
            ),

          // Language Loading Overlay
          if (_isLanguageLoading)
            const Positioned.fill(child: LanguageLoadingOverlay()),

          // Splash Screen Overlay
          if (_showSplash)
            Positioned.fill(
              child: SplashScreen(
                onFinish: () {
                  setState(() {
                    _showSplash = false;
                    _showBoot = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
