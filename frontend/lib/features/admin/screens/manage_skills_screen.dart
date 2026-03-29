import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../skills/models/skill_model.dart';
import '../services/admin_service.dart';
import '../widgets/admin_form_fields.dart';

class ManageSkillsScreen extends StatefulWidget {
  const ManageSkillsScreen({super.key});

  @override
  State<ManageSkillsScreen> createState() => _ManageSkillsScreenState();
}

class _ManageSkillsScreenState extends State<ManageSkillsScreen> {
  final AdminService _service = AdminService();
  List<SkillModel> _skills = [];
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
      _skills = await _service.fetchSkills(token);
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
                title: Text('Manage Skills',
                    style: GoogleFonts.firaCode(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kStarWhite)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: kSuccessGreen),
                    onPressed: () => _showForm(context),
                    tooltip: 'Create Skill',
                  ),
                ],
              ),
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(color: kNebulaPurple)),
                )
              else if (_skills.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text('No skills yet',
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
                        child: _buildCard(_skills[i])
                            .animate()
                            .fadeIn(delay: (60 * i).ms),
                      ),
                      childCount: _skills.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(SkillModel skill) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kNebulaPurple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: skill.iconUrl != null && skill.iconUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(skill.iconUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.code, color: kNebulaPurple, size: 20)),
                  )
                : const Icon(Icons.code, color: kNebulaPurple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skill.name,
                    style: GoogleFonts.firaCode(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTextPrimary)),
                if (skill.category != null)
                  Text(skill.category!,
                      style: GoogleFonts.nunito(
                          fontSize: 11, color: kTextMuted)),
              ],
            ),
          ),
          Text('#${skill.sortOrder}',
              style: GoogleFonts.firaCode(
                  fontSize: 11, color: kTextMuted)),
          IconButton(
            icon: const Icon(Icons.edit, size: 18, color: kCyberBlue),
            onPressed: () => _showForm(context, skill: skill),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
            onPressed: () => _confirmDelete(skill),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(SkillModel skill) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Skill',
            style: GoogleFonts.firaCode(color: kTextPrimary)),
        content: Text('Delete "${skill.name}"?',
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
                await _service.deleteSkill(skill.id, token);
                _load();
                if (mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Skill deleted')));
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

  void _showForm(BuildContext context, {SkillModel? skill}) {
    final nameC = TextEditingController(text: skill?.name ?? '');
    final iconC = TextEditingController(text: skill?.iconUrl ?? '');
    final categoryC = TextEditingController(text: skill?.category ?? '');
    final sortC =
        TextEditingController(text: '${skill?.sortOrder ?? 0}');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
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
                skill == null ? 'Create Skill' : 'Edit Skill',
                style: GoogleFonts.firaCode(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimary),
              ),
              const SizedBox(height: 16),
              AdminFormField(controller: nameC, label: 'Name *'),
              AdminFormField(controller: iconC, label: 'Icon URL'),
              AdminFormField(controller: categoryC, label: 'Category'),
              AdminFormField(
                controller: sortC,
                label: 'Sort Order',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _save(
                    ctx,
                    skill: skill,
                    name: nameC.text.trim(),
                    iconUrl: iconC.text.trim(),
                    category: categoryC.text.trim(),
                    sortOrder: int.tryParse(sortC.text.trim()) ?? 0,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kNebulaPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    skill == null ? 'Create' : 'Update',
                    style: GoogleFonts.firaCode(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext ctx, {
    SkillModel? skill,
    required String name,
    required String iconUrl,
    required String category,
    required int sortOrder,
  }) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Name is required')));
      return;
    }

    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final data = <String, dynamic>{
      'name': name,
      'sort_order': sortOrder,
    };
    if (iconUrl.isNotEmpty) data['icon_url'] = iconUrl;
    if (category.isNotEmpty) data['category'] = category;

    try {
      if (skill == null) {
        await _service.createSkill(data, token);
      } else {
        await _service.updateSkill(skill.id, data, token);
      }
      if (ctx.mounted) Navigator.pop(ctx);
      _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(skill == null ? 'Skill created' : 'Skill updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
