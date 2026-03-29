import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/glass_card.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      (icon: '👥', value: '4', label: 'Members'),
      (icon: '📅', value: '2024', label: 'Founded'),
      (icon: '🇰🇭', value: 'KH', label: 'Cambodia'),
      (icon: '⚡', value: 'Active', label: 'Status'),
    ];

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < stats.length; i++)
            Flexible(
              child: _StatItem(
                icon: stats[i].icon,
                value: stats[i].value,
                label: stats[i].label,
              )
                  .animate()
                  .fadeIn(delay: (150 * i).ms)
                  .scale(begin: const Offset(0.8, 0.8)),
            ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.firaCode(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kCyberBlue,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.nunito(fontSize: 11, color: kTextMuted),
        ),
      ],
    );
  }
}
