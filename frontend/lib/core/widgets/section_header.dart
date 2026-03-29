import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

/// Section header with gradient title + cosmic divider line
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => kButtonGradient.createShader(bounds),
          child: Text(
            title,
            style: GoogleFonts.firaCode(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 2,
          width: 60,
          decoration: const BoxDecoration(gradient: kButtonGradient),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: kTextSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
