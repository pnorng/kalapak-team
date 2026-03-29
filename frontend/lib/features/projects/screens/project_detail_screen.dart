import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/skill_chip.dart';
import '../models/project_model.dart';
import '../services/projects_service.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int id;
  const ProjectDetailScreen({super.key, required this.id});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final _service = ProjectsService();
  ProjectModel? _project;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await _service.fetchProject(widget.id);
      if (mounted) {
        setState(() {
          _project = p;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
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
    final p = _project!;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          expandedHeight: p.coverImage != null ? 220 : 0,
          flexibleSpace: p.coverImage != null
              ? FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: p.coverImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : null,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.title,
                        style: GoogleFonts.firaCode(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimary,
                        ),
                      ),
                    ),
                    if (p.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: kButtonGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('⭐ Featured',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                  ],
                ),
                if (p.description != null) ...[
                  const SizedBox(height: 12),
                  Text(p.description!,
                      style: GoogleFonts.nunito(
                          fontSize: 15, color: kTextSecondary, height: 1.6)),
                ],
                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tech Stack',
                          style: GoogleFonts.firaCode(
                              fontSize: 14,
                              color: kCyberBlue,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: p.techStack
                            .map((t) => SkillChip(label: t))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (p.githubUrl != null)
                      Expanded(
                        child: GradientButton(
                          label: 'GitHub',
                          icon: Icons.code,
                          onPressed: () => _launchUrl(p.githubUrl!),
                        ),
                      ),
                    if (p.githubUrl != null && p.liveUrl != null)
                      const SizedBox(width: 12),
                    if (p.liveUrl != null)
                      Expanded(
                        child: GradientButton(
                          label: 'Live Demo',
                          icon: Icons.open_in_new,
                          gradient: kPurpleGradient,
                          onPressed: () => _launchUrl(p.liveUrl!),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
