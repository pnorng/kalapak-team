import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Neon‑glowing chip for skill/tech badges
class SkillChip extends StatelessWidget {
  final String label;
  final String? iconUrl;
  final Color? glowColor;

  const SkillChip({
    super.key,
    required this.label,
    this.iconUrl,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kSurfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (glowColor ?? kCyberBlue).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? kCyberBlue).withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconUrl != null) ...[
            CachedNetworkImage(
              imageUrl: iconUrl!,
              width: 16,
              height: 16,
              errorWidget: (_, __, ___) => const SizedBox(width: 16),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: glowColor ?? kCyberBlue,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
