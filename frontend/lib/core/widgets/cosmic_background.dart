import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Animated starfield with floating particles — used as the Home screen background
class CosmicBackground extends StatefulWidget {
  final Widget child;
  const CosmicBackground({super.key, required this.child});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Star> _stars;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _stars = List.generate(80, (_) => _Star(_random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(gradient: kBgGradient),
        ),
        // Animated stars
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => CustomPaint(
            painter: _StarPainter(_stars, _controller.value),
            size: Size.infinite,
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Star {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double opacity;

  _Star(math.Random random) {
    x = random.nextDouble();
    y = random.nextDouble();
    size = random.nextDouble() * 2.5 + 0.5;
    speed = random.nextDouble() * 0.3 + 0.05;
    opacity = random.nextDouble() * 0.7 + 0.3;
  }
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double animation;

  _StarPainter(this.stars, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final y = (star.y + animation * star.speed) % 1.0;
      final paint = Paint()
        ..color = kStarWhite.withOpacity(
          star.opacity *
              (0.5 + 0.5 * math.sin(animation * math.pi * 2 + star.x * 10)),
        )
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 0.5);
      canvas.drawCircle(
        Offset(star.x * size.width, y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => true;
}
