import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/cosmic_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated || auth.user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const SizedBox.shrink();
        }

        final user = auth.user!;

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
                      onPressed: () => context.go('/'),
                    ),
                    title: Text(
                      'Profile',
                      style: GoogleFonts.firaCode(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kStarWhite,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: kCyberBlue),
                        tooltip: 'Edit Profile',
                        onPressed: () => context.push('/profile/edit'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: kTextSecondary),
                        tooltip: 'Logout',
                        onPressed: () => _confirmLogout(context, auth),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Avatar
                          _buildAvatar(user.name, user.avatar)
                              .animate()
                              .fadeIn()
                              .scale(begin: const Offset(0.8, 0.8)),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            user.name,
                            style: GoogleFonts.firaCode(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: kTextPrimary,
                            ),
                          ).animate().fadeIn(delay: 100.ms),
                          const SizedBox(height: 4),
                          // Role badge
                          _buildRoleBadge(user.role)
                              .animate()
                              .fadeIn(delay: 200.ms),
                          const SizedBox(height: 32),
                          // Info cards
                          _buildInfoCard(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: user.email,
                            color: kCyberBlue,
                          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            icon: Icons.badge_outlined,
                            label: 'User ID',
                            value: '#${user.id}',
                            color: kVioletAccent,
                          ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            icon: Icons.shield_outlined,
                            label: 'Role',
                            value: user.role.toUpperCase(),
                            color: user.isAdmin ? kSuccessGreen : kNebulaPurple,
                          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                          if (user.isAdmin) ...[
                            const SizedBox(height: 24),
                            _buildAdminDashboardButton(context)
                                .animate()
                                .fadeIn(delay: 550.ms),
                          ],
                          const SizedBox(height: 24),
                          // Edit Profile button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => context.push('/profile/edit'),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: Text(
                                'Edit Profile',
                                style: GoogleFonts.firaCode(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCyberBlue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ).animate().fadeIn(delay: 580.ms),
                          const SizedBox(height: 12),
                          // Logout button
                          SizedBox(
                            width: double.infinity,
                            child: _buildLogoutButton(context, auth),
                          ).animate().fadeIn(delay: 600.ms),
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
      },
    );
  }

  Widget _buildAvatar(String name, String? avatarUrl) {
    final initials = name
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: kButtonGradient,
        boxShadow: kNeonGlow(blur: 24),
      ),
      child: avatarUrl != null && avatarUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _initialsWidget(initials),
              ),
            )
          : _initialsWidget(initials),
    );
  }

  Widget _initialsWidget(String initials) {
    return Center(
      child: Text(
        initials,
        style: GoogleFonts.firaCode(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final isAdmin = role == 'admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: (isAdmin ? kSuccessGreen : kNebulaPurple).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isAdmin ? kSuccessGreen : kNebulaPurple).withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAdmin ? Icons.admin_panel_settings : Icons.person,
            size: 16,
            color: isAdmin ? kSuccessGreen : kNebulaPurple,
          ),
          const SizedBox(width: 6),
          Text(
            role.toUpperCase(),
            style: GoogleFonts.firaCode(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isAdmin ? kSuccessGreen : kNebulaPurple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: kTextMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.firaCode(
                    fontSize: 15,
                    color: kTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminDashboardButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push('/admin'),
        icon: const Icon(Icons.admin_panel_settings, size: 20),
        label: Text(
          'Admin Dashboard',
          style:
              GoogleFonts.firaCode(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: kSuccessGreen,
          side: BorderSide(color: kSuccessGreen.withOpacity(0.4)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return OutlinedButton.icon(
      onPressed: () => _confirmLogout(context, auth),
      icon: const Icon(Icons.logout, size: 20),
      label: Text(
        'Logout',
        style: GoogleFonts.firaCode(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.firaCode(color: kTextPrimary),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.nunito(color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.nunito(color: kTextMuted),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await auth.logout();
              if (context.mounted) context.go('/');
            },
            child: Text(
              'Logout',
              style: GoogleFonts.nunito(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
