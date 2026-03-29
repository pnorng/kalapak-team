import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/skill_chip.dart';
import '../providers/projects_provider.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().fetchProjects();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectsProvider>();

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
                    '{ Projects }',
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
                        title: 'Our Projects',
                        subtitle: 'Ideas we built and shipped',
                      ),
                      const SizedBox(height: 16),
                      // Search bar
                      TextField(
                        controller: _searchCtrl,
                        onChanged: (v) =>
                            context.read<ProjectsProvider>().search(v),
                        decoration: InputDecoration(
                          hintText: 'Search projects or tech...',
                          prefixIcon:
                              const Icon(Icons.search, color: kCyberBlue),
                          suffixIcon: _searchCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: kTextMuted),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    context.read<ProjectsProvider>().search('');
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (projects.isLoading)
                        const LoadingIndicator(message: 'Loading projects...')
                      else if (projects.error != null)
                        ErrorView(
                          message: projects.error!,
                          onRetry: () =>
                              context.read<ProjectsProvider>().fetchProjects(),
                        )
                      else if (projects.projects.isEmpty)
                        const Center(
                          child: Text('No projects found.',
                              style: TextStyle(color: kTextMuted)),
                        )
                      else
                        ...projects.projects.indexed.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ProjectCard(
                              project: entry.$2,
                              delay: (entry.$1 * 80),
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
}

class _ProjectCard extends StatelessWidget {
  final dynamic project;
  final int delay;

  const _ProjectCard({required this.project, required this.delay});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => context.push('/projects/${project.id}'),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          if (project.coverImage != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: project.coverImage!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  height: 160,
                  color: kSurfaceLight,
                  child:
                      const Icon(Icons.folder, color: kNebulaPurple, size: 48),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.title,
                        style: GoogleFonts.firaCode(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimary,
                        ),
                      ),
                    ),
                    if (project.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: kButtonGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '⭐ Featured',
                          style: GoogleFonts.spaceMono(
                            fontSize: 9,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                if (project.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    project.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.nunito(fontSize: 13, color: kTextSecondary),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (project.techStack as List<String>)
                      .map((t) => SkillChip(label: t))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2, end: 0);
  }
}
