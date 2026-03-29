import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/skill_chip.dart';
import '../providers/skills_provider.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SkillsProvider>().fetchSkills();
    });
  }

  static const Map<String, String> _categoryIcons = {
    'Languages': '💻',
    'Web Frontend': '🌐',
    'Backend & API': '⚙️',
    'Mobile': '📱',
    'Databases': '🗄️',
    'DevOps': '🐳',
  };

  @override
  Widget build(BuildContext context) {
    final skills = context.watch<SkillsProvider>();

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                title: ShaderMask(
                  shaderCallback: (b) => kButtonGradient.createShader(b),
                  child: Text(
                    '{ Skills }',
                    style: GoogleFonts.firaCode(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: 'Our Tech Stack',
                        subtitle: 'Technologies we master and love',
                      ),
                      const SizedBox(height: 24),
                      if (skills.isLoading)
                        const LoadingIndicator(message: 'Loading skills...')
                      else if (skills.error != null)
                        ErrorView(
                            message: skills.error!,
                            onRetry: () {
                              context.read<SkillsProvider>().fetchSkills();
                            })
                      else
                        ...skills.groupedSkills.entries.indexed.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildCategory(
                              icon: _categoryIcons[entry.$2.key] ?? '🔧',
                              category: entry.$2.key,
                              skillList: entry.$2.value,
                              delay: entry.$1 * 100,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory({
    required String icon,
    required String category,
    required List skillList,
    required int delay,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                category,
                style: GoogleFonts.firaCode(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kStarWhite,
                ),
              ),
              const Spacer(),
              Text(
                '${skillList.length} skills',
                style: GoogleFonts.spaceMono(fontSize: 10, color: kTextMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          LinearProgressIndicator(
            value: (skillList.length / 6).clamp(0.0, 1.0),
            backgroundColor: kSurfaceLight,
            valueColor: const AlwaysStoppedAnimation(kNebulaPurple),
            minHeight: 3,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skillList
                .map((s) => SkillChip(label: s.name, iconUrl: s.iconUrl))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2, end: 0);
  }
}
