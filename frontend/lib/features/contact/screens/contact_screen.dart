import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/section_header.dart';
import '../providers/contact_provider.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  static const _socials = [
    (
      Icons.code,
      'GitHub',
      'https://github.com/kalapak-code-team',
      kTextPrimary
    ),
    (Icons.telegram, 'Telegram', 'https://t.me/kalapak_team', kCyberBlue),
    (
      Icons.facebook_outlined,
      'Facebook',
      'https://fb.com/kalapakteam',
      kNebulaPurple
    ),
    (Icons.email_outlined, 'Email', 'mailto:hello@kalapak.team', kSuccessGreen),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ContactProvider>();
    await provider.send(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      subject: _subjectCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
    );
    if (!mounted) return;
    if (provider.status == ContactStatus.success) {
      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _emailCtrl.clear();
      _subjectCtrl.clear();
      _messageCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message sent! We\'ll get back to you soon 🚀'),
          backgroundColor: kSuccessGreen,
        ),
      );
      provider.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (b) => kButtonGradient.createShader(b),
                  child: Text('Contact Us',
                      style: GoogleFonts.firaCode(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ).animate().fadeIn().slideY(begin: -0.3),
                const SizedBox(height: 8),
                Text('Get in touch with the Kalapak team 🇰🇭',
                        style: GoogleFonts.nunito(
                            fontSize: 14, color: kTextSecondary))
                    .animate()
                    .fadeIn(delay: 100.ms),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Find Us'),
                const SizedBox(height: 14),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.8,
                  children: _socials.map((s) {
                    final (icon, label, url, color) = s;
                    return GestureDetector(
                      onTap: () => _launch(url),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Icon(icon, color: color, size: 18),
                            const SizedBox(width: 8),
                            Text(label,
                                style: GoogleFonts.nunito(
                                    fontSize: 13, color: kTextPrimary)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 150.ms),
                const SizedBox(height: 28),
                const SectionHeader(title: 'Send a Message'),
                const SizedBox(height: 14),
                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _Field(
                          ctrl: _nameCtrl,
                          label: 'Name',
                          icon: Icons.person_outline,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _Field(
                          ctrl: _emailCtrl,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _Field(
                          ctrl: _subjectCtrl,
                          label: 'Subject',
                          icon: Icons.subject_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _Field(
                          ctrl: _messageCtrl,
                          label: 'Message',
                          icon: Icons.message_outlined,
                          maxLines: 5,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Required';
                            }
                            if (v.trim().length < 10) return 'Too short';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Consumer<ContactProvider>(
                          builder: (_, provider, __) {
                            final isLoading =
                                provider.status == ContactStatus.loading;
                            return Column(
                              children: [
                                if (provider.status == ContactStatus.error)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(provider.error,
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12)),
                                  ),
                                SizedBox(
                                  width: double.infinity,
                                  child: GradientButton(
                                    label:
                                        isLoading ? 'Sending…' : 'Send Message',
                                    icon: Icons.send_rounded,
                                    onPressed: isLoading ? null : _submit,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: kTextPrimary),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kTextMuted, size: 18),
      ),
    );
  }
}
