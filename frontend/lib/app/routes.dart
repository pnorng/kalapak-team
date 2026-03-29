import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/skills/screens/skills_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/projects/screens/project_detail_screen.dart';
import '../features/blog/screens/blog_screen.dart';
import '../features/blog/screens/post_detail_screen.dart';
import '../features/about/screens/about_screen.dart';
import '../features/contact/screens/contact_screen.dart';
import '../features/auth/screens/profile_screen.dart';
import '../features/auth/screens/edit_profile_screen.dart';
import '../features/admin/screens/admin_dashboard_screen.dart';
import '../features/admin/screens/manage_posts_screen.dart';
import '../features/admin/screens/manage_projects_screen.dart';
import '../features/admin/screens/manage_skills_screen.dart';
import '../features/admin/screens/manage_messages_screen.dart';
import '../shared/navigation/bottom_nav.dart';

class AppRoutes {
  static const String home = '/';
  static const String skills = '/skills';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String blog = '/blog';
  static const String postDetail = '/blog/:slug';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String adminDashboard = '/admin';
  static const String adminPosts = '/admin/posts';
  static const String adminProjects = '/admin/projects';
  static const String adminSkills = '/admin/skills';
  static const String adminMessages = '/admin/messages';
}

GoRouter createRouter(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      // No forced auth redirect — most routes are public
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (c, s) => const HomeScreen()),
          GoRoute(
              path: AppRoutes.skills, builder: (c, s) => const SkillsScreen()),
          GoRoute(
              path: AppRoutes.projects,
              builder: (c, s) => const ProjectsScreen()),
          GoRoute(path: AppRoutes.blog, builder: (c, s) => const BlogScreen()),
          GoRoute(
              path: AppRoutes.about, builder: (c, s) => const AboutScreen()),
          GoRoute(
              path: AppRoutes.contact,
              builder: (c, s) => const ContactScreen()),
        ],
      ),
      GoRoute(
        path: AppRoutes.projectDetail,
        builder: (c, s) =>
            ProjectDetailScreen(id: int.parse(s.pathParameters['id']!)),
      ),
      GoRoute(
        path: AppRoutes.postDetail,
        builder: (c, s) => PostDetailScreen(slug: s.pathParameters['slug']!),
      ),
      GoRoute(path: AppRoutes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(
          path: AppRoutes.register, builder: (c, s) => const RegisterScreen()),
      GoRoute(
          path: AppRoutes.profile, builder: (c, s) => const ProfileScreen()),
      GoRoute(
          path: AppRoutes.editProfile,
          builder: (c, s) => const EditProfileScreen()),
      GoRoute(
          path: AppRoutes.adminDashboard,
          builder: (c, s) => const AdminDashboardScreen()),
      GoRoute(
          path: AppRoutes.adminPosts,
          builder: (c, s) => const ManagePostsScreen()),
      GoRoute(
          path: AppRoutes.adminProjects,
          builder: (c, s) => const ManageProjectsScreen()),
      GoRoute(
          path: AppRoutes.adminSkills,
          builder: (c, s) => const ManageSkillsScreen()),
      GoRoute(
          path: AppRoutes.adminMessages,
          builder: (c, s) => const ManageMessagesScreen()),
    ],
  );
}
