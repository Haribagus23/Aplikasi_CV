import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/animated_fade_slide.dart';
import '../utils/app_strings.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  // Staggered Animations
  late Animation<double> _fadeTitle;
  late Animation<Offset> _slideTitle;
  late Animation<double> _fadeForm;
  late Animation<Offset> _slideForm;
  late Animation<double> _fadeSocials;
  late Animation<Offset> _slideSocials;

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    Animation<double> createFade(double start, double end) {
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );
    }

    Animation<Offset> createSlide(double start, double end) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    }

    _fadeTitle = createFade(0.0, 0.4);
    _slideTitle = createSlide(0.0, 0.4);

    _fadeForm = createFade(0.2, 0.7);
    _slideForm = createSlide(0.2, 0.7);

    _fadeSocials = createFade(0.5, 1.0);
    _slideSocials = createSlide(0.5, 1.0);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

  void _sendMessage() async {
    final strings = AppStrings.of(context);
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      final String name = _nameController.text;
      final String email = _emailController.text;
      final String body = _messageController.text;

      // Create mailto URL
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'almuaqafa42@gmail.com', // Replace with actual email
        query: _encodeQueryParameters(<String, String>{
          'subject': '${strings.txtEmailSubject} $name',
          'body':
              '${strings.txtEmailBodyName}: $name\n${strings.txtEmailBodyEmail}: $email\n\n${strings.txtEmailBodyMessage}:\n$body',
        }),
      );

      await launchUrl(emailLaunchUri);

      setState(() => _isSending = false);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.msgSending)));
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textTheme = Theme.of(context).textTheme;
    final strings = AppStrings.of(context);

    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth > 600
              ? 600.0
              : constraints.maxWidth;

          return Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Heading
                    AnimatedFadeSlide(
                      fade: _fadeTitle,
                      slide: _slideTitle,
                      child: Column(
                        children: [
                          Text(
                            strings.contactTitle,
                            style: textTheme.headlineLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 48,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            strings.contactSubtitle,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Contact Form
                    AnimatedFadeSlide(
                      fade: _fadeForm,
                      slide: _slideForm,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _CustomTextField(
                                controller: _nameController,
                                label: strings.labelName,
                                icon: Icons.person_outline,
                                validator: (value) =>
                                    value!.isEmpty ? strings.msgFillName : null,
                              ),
                              const SizedBox(height: 20),
                              _CustomTextField(
                                controller: _emailController,
                                label: strings.labelEmail,
                                icon: Icons.email_outlined,
                                validator: (value) => !value!.contains('@')
                                    ? strings.msgFillEmail
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              _CustomTextField(
                                controller: _messageController,
                                label: strings.labelMessage,
                                icon: Icons.message_outlined,
                                maxLines: 4,
                                validator: (value) => value!.isEmpty
                                    ? strings.msgFillMessage
                                    : null,
                              ),
                              const SizedBox(height: 32),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isSending ? null : _sendMessage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    foregroundColor: Theme.of(
                                      context,
                                    ).scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isSending
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.send_rounded),
                                            const SizedBox(width: 8),
                                            Text(
                                              strings.btnSend,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Footer / Socials
                    AnimatedFadeSlide(
                      fade: _fadeSocials,
                      slide: _slideSocials,
                      child: Column(
                        children: [
                          // Quick Connect Buttons
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              _SocialButton(
                                label: "GitHub",
                                icon: Icons.code,
                                onTap: () =>
                                    _launchURL('https://github.com/haribagus'),
                              ),
                              _SocialButton(
                                label: "LinkedIn",
                                icon: Icons.business_center_outlined,
                                onTap: () => _launchURL(
                                  'https://linkedin.com/in/haribagus',
                                ),
                              ),
                              _SocialButton(
                                label: "WhatsApp",
                                icon: Icons.chat_bubble_outline,
                                onTap: () => _launchURL(
                                  'https://wa.me/6281234567890',
                                ), // Replace with actual number
                              ),
                            ],
                          ),

                          const SizedBox(height: 48),

                          // Location Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  strings.basedIn,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                          Text(
                            strings.txtCopyright,
                            style: textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ), // Space for FloatingNavBar
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.redAccent.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovering
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _isHovering
                  ? Colors.transparent
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovering
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _isHovering
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
