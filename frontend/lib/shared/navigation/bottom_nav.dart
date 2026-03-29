import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  static const _tabs = [
    (
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
      path: '/'
    ),
    (
      icon: Icons.code_outlined,
      activeIcon: Icons.code_rounded,
      label: 'Skills',
      path: '/skills'
    ),
    (
      icon: Icons.rocket_launch_outlined,
      activeIcon: Icons.rocket_launch_rounded,
      label: 'Projects',
      path: '/projects'
    ),
    (
      icon: Icons.article_outlined,
      activeIcon: Icons.article_rounded,
      label: 'Blog',
      path: '/blog'
    ),
    (
      icon: Icons.group_outlined,
      activeIcon: Icons.group_rounded,
      label: 'About',
      path: '/about'
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (i == 0 && location == '/') return 0;
      if (i > 0 && location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kSurface.withOpacity(0.95),
          border: Border(
            top: BorderSide(color: kBorderColor.withOpacity(0.6), width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: kNebulaPurple.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: currentIndex,
          indicatorColor: kNebulaPurple.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (i) => context.go(_tabs[i].path),
          destinations: _tabs
              .map((t) => NavigationDestination(
                    icon: Icon(t.icon, size: 22),
                    selectedIcon:
                        Icon(t.activeIcon, size: 22, color: kNebulaPurple),
                    label: t.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
