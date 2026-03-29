import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _textIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % AppStrings.heroTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: kNebulaPurple.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(20),
            color: kNebulaPurple.withOpacity(0.1),
          ),
          child: Text(
            '⚡ Kalapak Code Team',
            style: GoogleFonts.spaceMono(fontSize: 11, color: kCyberBlue),
          ),
        ).animate().fadeIn().slideX(begin: -0.3, end: 0),
        const SizedBox(height: 16),
        // Hero title
        ShaderMask(
          shaderCallback: (b) => kButtonGradient.createShader(b),
          child: Text(
            'Coding\nthe Universe',
            style: GoogleFonts.firaCode(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        // Typewriter animation
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            AppStrings.heroTexts[_textIndex],
            key: ValueKey(_textIndex),
            style: GoogleFonts.nunito(
              fontSize: 15,
              color: kStarWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 8),
        Text(
          'Cambodia 🇰🇭 · Since 2024 · Open Source',
          style: GoogleFonts.nunito(fontSize: 13, color: kTextMuted),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}
