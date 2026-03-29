import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';

class MissionSteps extends StatelessWidget {
  const MissionSteps({super.key});

  static const _steps = [
    ('🔭', 'RESEARCH', 'Explore cutting-edge technologies'),
    ('📝', 'DOCUMENT', 'Share what we learn with the community'),
    ('⚗️', 'DEVELOP', 'Build real-world projects & solutions'),
    ('🚀', 'SHOWCASE', 'Demonstrate skills through our portfolio'),
    ('🤝', 'HELP OTHERS', 'Grow the dev community in Cambodia'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _steps.asMap().entries.map((entry) {
        final i = entry.key;
        final (emoji, title, desc) = entry.value;
        return _StepTile(
          index: i + 1,
          emoji: emoji,
          title: title,
          desc: desc,
          isLast: i == _steps.length - 1,
        ).animate().fadeIn(delay: (i * 120).ms).slideX(begin: -0.3);
      }).toList(),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final String emoji;
  final String title;
  final String desc;
  final bool isLast;

  const _StepTile({
    required this.index,
    required this.emoji,
    required this.title,
    required this.desc,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: kButtonGradient,
                  shape: BoxShape.circle,
                  boxShadow: kNeonGlow(),
                ),
                child: Center(
                  child: Text('$index',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: kNebulaPurple.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(title,
                          style: GoogleFonts.firaCode(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kCyberBlue)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc,
                      style: GoogleFonts.nunito(
                          fontSize: 13, color: kTextSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
