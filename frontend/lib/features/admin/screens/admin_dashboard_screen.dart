import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../blog/providers/blog_provider.dart';
import '../../projects/providers/projects_provider.dart';
import '../../skills/providers/skills_provider.dart';
import '../providers/admin_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final auth = context.read<AuthProvider>();
    if (!auth.isAdmin || auth.token == null) return;

    context.read<BlogProvider>().fetchPosts();
    context.read<ProjectsProvider>().fetchProjects();
    context.read<SkillsProvider>().fetchSkills();
    context.read<AdminProvider>().fetchMessages(auth.token!);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated || !auth.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildWelcome(auth),
                      const SizedBox(height: 24),
                      _buildStatsGrid(),
                      const SizedBox(height: 28),
                      _buildManagementSection(),
                      const SizedBox(height: 28),
                      _buildMessagesSection(),
                      const SizedBox(height: 40),
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

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: kCyberBlue),
        onPressed: () => context.go('/'),
      ),
      title: Row(
        children: [
          const Icon(Icons.admin_panel_settings,
              color: kSuccessGreen, size: 22),
          const SizedBox(width: 8),
          Text(
            'Admin Dashboard',
            style: GoogleFonts.firaCode(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kStarWhite,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: kTextSecondary),
          onPressed: _loadData,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildWelcome(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: GoogleFonts.nunito(fontSize: 14, color: kTextMuted),
        ),
        Text(
          auth.user?.name ?? 'Admin',
          style: GoogleFonts.firaCode(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: kTextPrimary,
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.05);
  }

  Widget _buildStatsGrid() {
    return Consumer4<BlogProvider, ProjectsProvider, SkillsProvider,
        AdminProvider>(
      builder: (_, blog, projects, skills, admin, __) {
        final totalSkills = skills.groupedSkills.values
            .fold<int>(0, (sum, list) => sum + list.length);

        final stats = [
          _StatData(
            icon: Icons.article,
            label: 'Posts',
            value: '${blog.posts.length}',
            color: kVioletAccent,
          ),
          _StatData(
            icon: Icons.rocket_launch,
            label: 'Projects',
            value: '${projects.projects.length}',
            color: kCyberBlue,
          ),
          _StatData(
            icon: Icons.code,
            label: 'Skills',
            value: '$totalSkills',
            color: kNebulaPurple,
          ),
          _StatData(
            icon: Icons.mail,
            label: 'Messages',
            value: '${admin.messages.length}',
            color: kSkyBlue,
            badge: admin.unreadCount > 0 ? '${admin.unreadCount}' : null,
          ),
        ];

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: stats.length,
          itemBuilder: (_, i) => _buildStatCard(stats[i])
              .animate()
              .fadeIn(delay: (100 * i).ms)
              .scale(begin: const Offset(0.9, 0.9)),
        );
      },
    );
  }

  Widget _buildStatCard(_StatData data) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: data.color, size: 20),
              ),
              if (data.badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${data.badge} new',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: GoogleFonts.firaCode(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimary,
                ),
              ),
              Text(
                data.label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagementSection() {
    final items = [
      const _ManageItem(
        icon: Icons.article_outlined,
        label: 'Manage Posts',
        desc: 'Create, edit, delete blog posts',
        color: kVioletAccent,
        route: '/admin/posts',
      ),
      const _ManageItem(
        icon: Icons.rocket_launch_outlined,
        label: 'Manage Projects',
        desc: 'Update portfolio projects',
        color: kCyberBlue,
        route: '/admin/projects',
      ),
      const _ManageItem(
        icon: Icons.code_outlined,
        label: 'Manage Skills',
        desc: 'Add or remove team skills',
        color: kNebulaPurple,
        route: '/admin/skills',
      ),
      const _ManageItem(
        icon: Icons.mail_outlined,
        label: 'Messages',
        desc: 'View & manage contact messages',
        color: kSkyBlue,
        route: '/admin/messages',
      ),
      const _ManageItem(
        icon: Icons.person_outline,
        label: 'My Profile',
        desc: 'View profile & account',
        color: kSuccessGreen,
        route: '/profile',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Management',
          style: GoogleFonts.firaCode(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kStarWhite,
          ),
        ),
        const SizedBox(height: 12),
        ...items.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildManageCard(e.value)
                  .animate()
                  .fadeIn(delay: (150 * e.key).ms)
                  .slideX(begin: 0.05),
            )),
      ],
    );
  }

  Widget _buildManageCard(_ManageItem item) {
    return GlassCard(
      onTap: () => context.push(item.route),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: GoogleFonts.firaCode(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.desc,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: kTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: kTextMuted.withOpacity(0.5), size: 20),
        ],
      ),
    );
  }

  Widget _buildMessagesSection() {
    return Consumer<AdminProvider>(
      builder: (_, admin, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact Messages',
                  style: GoogleFonts.firaCode(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kStarWhite,
                  ),
                ),
                if (admin.unreadCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${admin.unreadCount} unread',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (admin.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: kNebulaPurple),
                ),
              )
            else if (admin.messages.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.inbox_outlined, color: kTextMuted, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'No messages yet',
                        style:
                            GoogleFonts.nunito(color: kTextMuted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...admin.messages
                  .take(10)
                  .toList()
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildMessageCard(e.value, admin)
                            .animate()
                            .fadeIn(delay: (80 * e.key).ms),
                      )),
          ],
        );
      },
    );
  }

  Widget _buildMessageCard(dynamic msg, AdminProvider admin) {
    final token = context.read<AuthProvider>().token;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderColor: msg.isRead ? null : kCyberBlue.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!msg.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: kCyberBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  msg.subject,
                  style: GoogleFonts.firaCode(
                    fontSize: 13,
                    fontWeight: msg.isRead ? FontWeight.w400 : FontWeight.w600,
                    color: kTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!msg.isRead && token != null)
                GestureDetector(
                  onTap: () => admin.markRead(msg.id, token),
                  child: const Icon(Icons.check_circle_outline,
                      color: kSuccessGreen, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: kTextMuted),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${msg.name} · ${msg.email}',
                  style: GoogleFonts.nunito(fontSize: 11, color: kTextMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            msg.message,
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: kTextSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (msg.createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              _formatDate(msg.createdAt!),
              style: GoogleFonts.nunito(fontSize: 10, color: kTextMuted),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _StatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? badge;

  const _StatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.badge,
  });
}

class _ManageItem {
  final IconData icon;
  final String label;
  final String desc;
  final Color color;
  final String route;

  const _ManageItem({
    required this.icon,
    required this.label,
    required this.desc,
    required this.color,
    required this.route,
  });
}
