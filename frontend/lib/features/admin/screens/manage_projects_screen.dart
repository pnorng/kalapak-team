import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../projects/models/project_model.dart';
import '../services/admin_service.dart';
import '../widgets/admin_form_fields.dart';

class ManageProjectsScreen extends StatefulWidget {
  const ManageProjectsScreen({super.key});

  @override
  State<ManageProjectsScreen> createState() => _ManageProjectsScreenState();
}

class _ManageProjectsScreenState extends State<ManageProjectsScreen> {
  final AdminService _service = AdminService();
  List<ProjectModel> _projects = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    setState(() => _loading = true);
    try {
      _projects = await _service.fetchProjects(token);
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: kCyberBlue),
                  onPressed: () => context.pop(),
                ),
                title: Text('Manage Projects',
                    style: GoogleFonts.firaCode(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kStarWhite)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: kSuccessGreen),
                    onPressed: () => _showForm(context),
                    tooltip: 'Create Project',
                  ),
                ],
              ),
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(color: kNebulaPurple)),
                )
              else if (_projects.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text('No projects yet',
                        style: GoogleFonts.nunito(color: kTextMuted)),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildCard(_projects[i])
                            .animate()
                            .fadeIn(delay: (60 * i).ms),
                      ),
                      childCount: _projects.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(ProjectModel project) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(project.title,
                    style: GoogleFonts.firaCode(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: kCyberBlue),
                    onPressed: () => _showForm(context, project: project),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        size: 18, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(project),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ],
              ),
            ],
          ),
          if (project.description != null) ...[
            const SizedBox(height: 4),
            Text(project.description!,
                style:
                    GoogleFonts.nunito(fontSize: 12, color: kTextSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (project.isFeatured)
                _chip('Featured', kSuccessGreen),
              ...project.techStack
                  .take(4)
                  .map((t) => _chip(t, kCyberBlue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: GoogleFonts.nunito(
              fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }

  void _confirmDelete(ProjectModel project) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Project',
            style: GoogleFonts.firaCode(color: kTextPrimary)),
        content: Text('Delete "${project.title}"?',
            style: GoogleFonts.nunito(color: kTextSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: GoogleFonts.nunito(color: kTextMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final token = context.read<AuthProvider>().token;
              if (token == null) return;
              try {
                await _service.deleteProject(project.id, token);
                _load();
                if (mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Project deleted')));
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete')));
                }
              }
            },
            child: Text('Delete',
                style: GoogleFonts.nunito(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, {ProjectModel? project}) {
    final titleC = TextEditingController(text: project?.title ?? '');
    final descC = TextEditingController(text: project?.description ?? '');
    final coverC = TextEditingController(text: project?.coverImage ?? '');
    final techC =
        TextEditingController(text: project?.techStack.join(', ') ?? '');
    final githubC = TextEditingController(text: project?.githubUrl ?? '');
    final liveC = TextEditingController(text: project?.liveUrl ?? '');
    bool isFeatured = project?.isFeatured ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project == null ? 'Create Project' : 'Edit Project',
                  style: GoogleFonts.firaCode(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimary),
                ),
                const SizedBox(height: 16),
                AdminFormField(controller: titleC, label: 'Title *'),
                AdminFormField(
                    controller: descC, label: 'Description', maxLines: 3),
                AdminFormField(
                    controller: coverC, label: 'Cover Image URL'),
                AdminFormField(
                    controller: techC,
                    label: 'Tech Stack (comma separated)'),
                AdminFormField(
                    controller: githubC, label: 'GitHub URL'),
                AdminFormField(controller: liveC, label: 'Live URL'),
                AdminSwitchField(
                  label: 'Featured',
                  value: isFeatured,
                  onChanged: (v) => setModalState(() => isFeatured = v),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _save(
                      ctx,
                      project: project,
                      title: titleC.text.trim(),
                      description: descC.text.trim(),
                      coverImage: coverC.text.trim(),
                      techStack: techC.text.trim(),
                      githubUrl: githubC.text.trim(),
                      liveUrl: liveC.text.trim(),
                      isFeatured: isFeatured,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNebulaPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      project == null ? 'Create' : 'Update',
                      style: GoogleFonts.firaCode(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext ctx, {
    ProjectModel? project,
    required String title,
    required String description,
    required String coverImage,
    required String techStack,
    required String githubUrl,
    required String liveUrl,
    required bool isFeatured,
  }) async {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final data = <String, dynamic>{
      'title': title,
      'is_featured': isFeatured,
    };
    if (description.isNotEmpty) data['description'] = description;
    if (coverImage.isNotEmpty) data['cover_image'] = coverImage;
    if (techStack.isNotEmpty) {
      data['tech_stack'] =
          techStack.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    if (githubUrl.isNotEmpty) data['github_url'] = githubUrl;
    if (liveUrl.isNotEmpty) data['live_url'] = liveUrl;

    try {
      if (project == null) {
        await _service.createProject(data, token);
      } else {
        await _service.updateProject(project.id, data, token);
      }
      if (ctx.mounted) Navigator.pop(ctx);
      _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(project == null ? 'Project created' : 'Project updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
