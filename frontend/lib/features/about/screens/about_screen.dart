import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/section_header.dart';
import '../models/member_model.dart';
import '../widgets/member_card.dart';
import '../widgets/mission_steps.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
  List<MemberModel> _members = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await _dio.get(ApiEndpoints.team);
      final data = res.data['data'] as List;
      _members = data
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: _isLoading
              ? const LoadingIndicator()
              : _error != null
                  ? ErrorView(message: _error!, onRetry: _load)
                  : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (b) => kButtonGradient.createShader(b),
            child: Text('About Us',
                style: GoogleFonts.firaCode(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ).animate().fadeIn().slideY(begin: -0.3),
          const SizedBox(height: 8),
          Text('A team of Cambodian developers building cool things 🇰🇭',
                  style:
                      GoogleFonts.nunito(fontSize: 14, color: kTextSecondary))
              .animate()
              .fadeIn(delay: 100.ms),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🚀', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Text('Kalapak Code Team',
                        style: GoogleFonts.firaCode(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextPrimary)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Founded in 2024, Kalapak Code Team is a group of passionate '
                  'full-stack developers from Cambodia. We build open-source projects, '
                  'write technical blog posts, and share our journey from student coders '
                  'to professional software engineers.',
                  style: GoogleFonts.nunito(
                      fontSize: 14, color: kTextSecondary, height: 1.6),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    'Flutter',
                    'Laravel',
                    'PostgreSQL',
                    'Docker',
                    'Cambodia 🇰🇭'
                  ]
                      .map((t) => Chip(
                            label: Text(t,
                                style: const TextStyle(
                                    fontSize: 11, color: kCyberBlue)),
                            backgroundColor: kCyberBlue.withOpacity(0.1),
                            side:
                                BorderSide(color: kCyberBlue.withOpacity(0.4)),
                            padding: EdgeInsets.zero,
                          ))
                      .toList(),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Our Mission'),
          const SizedBox(height: 16),
          const MissionSteps(),
          const SizedBox(height: 28),
          const SectionHeader(title: 'The Team'),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _members.length,
            itemBuilder: (_, i) => MemberCard(member: _members[i])
                .animate()
                .fadeIn(delay: (i * 80).ms),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
