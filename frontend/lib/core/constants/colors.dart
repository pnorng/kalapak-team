import 'package:flutter/material.dart';

// ── Primary Background Colors ──────────────────────────────────────────
const Color kDeepSpace = Color(0xFF020024);
const Color kCosmicPurple = Color(0xFF0D0A3E);
const Color kNebulaPurple = Color(0xFF7B2FFF);

// ── Accent Colors ──────────────────────────────────────────────────────
const Color kCyberBlue = Color(0xFF00D4FF);
const Color kStarWhite = Color(0xFFC4B5FD);
const Color kVioletAccent = Color(0xFFA78BFA);
const Color kIndigoDeep = Color(0xFF4F46E5);
const Color kCyanAccent = Color(0xFF06B6D4);
const Color kSkyBlue = Color(0xFF0EA5E9);
const Color kSuccessGreen = Color(0xFF00FF88);

// ── Text Colors ────────────────────────────────────────────────────────
const Color kTextPrimary = Color(0xFFF1F5F9);
const Color kTextSecondary = Color(0xFF94A3B8);
const Color kTextMuted = Color(0xFF64748B);

// ── Surface Colors ─────────────────────────────────────────────────────
const Color kSurface = Color(0xFF0F0C2E);
const Color kSurfaceLight = Color(0xFF1A1645);
const Color kGlassOverlay = Color(0x1AFFFFFF);
const Color kBorderColor = Color(0x337B2FFF);

// ── Gradients ─────────────────────────────────────────────────────────
const LinearGradient kBgGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kDeepSpace, kCosmicPurple, Color(0xFF150A4E)],
);

const LinearGradient kButtonGradient = LinearGradient(
  colors: [kNebulaPurple, kCyberBlue],
);

const LinearGradient kCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0x2A7B2FFF), Color(0x1500D4FF)],
);

const LinearGradient kPurpleGradient = LinearGradient(
  colors: [kNebulaPurple, kIndigoDeep],
);

// ── Glow Shadow ────────────────────────────────────────────────────────
List<BoxShadow> kNeonGlow({Color color = kNebulaPurple, double blur = 20}) => [
      BoxShadow(
          color: color.withOpacity(0.4), blurRadius: blur, spreadRadius: 2),
      BoxShadow(color: color.withOpacity(0.2), blurRadius: blur * 2),
    ];

List<BoxShadow> kCyberGlow({double blur = 16}) => [
      BoxShadow(
          color: kCyberBlue.withOpacity(0.35),
          blurRadius: blur,
          spreadRadius: 1),
    ];
