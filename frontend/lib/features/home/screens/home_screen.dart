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
import '../widgets/hero_section.dart';
import '../widgets/stats_row.dart';
import '../widgets/recent_posts_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: ShaderMask(
                  shaderCallback: (b) => kButtonGradient.createShader(b),
                  child: Text(
                    '{ Kalapak }',
                    style: GoogleFonts.firaCode(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => auth.isAuthenticated
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (auth.isAdmin)
                                IconButton(
                                  icon: const Icon(Icons.admin_panel_settings,
                                      color: kSuccessGreen),
                                  onPressed: () => context.push('/admin'),
                                  tooltip: 'Admin Dashboard',
                                ),
                              GestureDetector(
                                onTap: () => context.push('/profile'),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: _buildNavAvatar(auth),
                                ),
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: () => context.push('/login'),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: kCyberBlue),
                            ),
                          ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeroSection(),
                      const SizedBox(height: 32),
                      const StatsRow(),
                      const SizedBox(height: 32),
                      _buildNavCards(context),
                      const SizedBox(height: 32),
                      const RecentPostsPreview(),
                      const SizedBox(height: 24),
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

  Widget _buildNavCards(BuildContext context) {
    final cards = [
      (
        icon: Icons.code,
        label: 'Skills',
        route: '/skills',
        color: kNebulaPurple
      ),
      (
        icon: Icons.folder_special,
        label: 'Projects',
        route: '/projects',
        color: kCyberBlue
      ),
      (
        icon: Icons.article,
        label: 'Blog',
        route: '/blog',
        color: kVioletAccent
      ),
      (icon: Icons.group, label: 'About', route: '/about', color: kCyanAccent),
      (
        icon: Icons.mail_outline,
        label: 'Contact',
        route: '/contact',
        color: kSkyBlue
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore',
          style: GoogleFonts.firaCode(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kStarWhite,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 400 ? 3 : 2;
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: cards.length,
              itemBuilder: (context, i) {
                final c = cards[i];
                return GlassCard(
                  onTap: () => context.go(c.route),
                  padding: const EdgeInsets.all(8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(c.icon, color: c.color, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          c.label,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: kTextPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: (100 * i).ms)
                    .slideY(begin: 0.3, end: 0);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNavAvatar(AuthProvider auth) {
    final name = auth.user?.name ?? '';
    final avatar = auth.user?.avatar;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 16,
      backgroundColor: kNebulaPurple.withOpacity(0.25),
      backgroundImage:
          (avatar != null && avatar.isNotEmpty) ? NetworkImage(avatar) : null,
      onBackgroundImageError:
          (avatar != null && avatar.isNotEmpty) ? (_, __) {} : null,
      child: (avatar == null || avatar.isEmpty)
          ? Text(
              initial,
              style: GoogleFonts.firaCode(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: kNebulaPurple,
              ),
            )
          : null,
    );
  }
}
