import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Gradient button with optional glow effect
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final bool isLoading;
  final LinearGradient? gradient;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(colors: [kTextMuted, kTextMuted])
              : (gradient ?? kButtonGradient),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isLoading ? null : kNeonGlow(),
        ),
        child: Row(
          mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
