import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/skills/providers/skills_provider.dart';
import '../features/projects/providers/projects_provider.dart';
import '../features/blog/providers/blog_provider.dart';
import '../features/contact/providers/contact_provider.dart';
import '../features/admin/providers/admin_provider.dart';
import '../features/auth/services/auth_service.dart';
import 'routes.dart';
import 'theme.dart';

class KalapakApp extends StatelessWidget {
  const KalapakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => SkillsProvider()),
        ChangeNotifierProvider(create: (_) => ProjectsProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Builder(
        builder: (context) {
          final router = createRouter(context);
          return MaterialApp.router(
            title: 'Kalapak',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
