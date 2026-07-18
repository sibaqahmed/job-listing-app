import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/theme_provider.dart';
import '../widgets/animated_shining_title.dart';
import '../tabs/roles_tab.dart';
import 'applications_tab.dart';
import 'messages_tab.dart';

class RolesListScreen extends ConsumerStatefulWidget {
  const RolesListScreen({Key? key}) : super(key: key);

  @override
  _RolesListScreenState createState() => _RolesListScreenState();
}

class _RolesListScreenState extends ConsumerState<RolesListScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late final AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _showThemeDialog(BuildContext context, WidgetRef ref) async {
    final current = ref.read(themeNotifierProvider);
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Choose theme'),
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: current,
              title: const Text('System default'),
              onChanged: (v) => Navigator.of(ctx).pop(v),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: current,
              title: const Text('Light'),
              onChanged: (v) => Navigator.of(ctx).pop(v),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: current,
              title: const Text('Dark'),
              onChanged: (v) => Navigator.of(ctx).pop(v),
            ),
          ],
        );
      },
    );

    if (selected != null) {
      await ref.read(themeNotifierProvider.notifier).setTheme(selected);
    }
  }

  void _onMenuSelected(BuildContext context, WidgetRef ref, _MenuAction action) {
    switch (action) {
      case _MenuAction.profile:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile tapped')));
        break;
      case _MenuAction.theme:
        _showThemeDialog(context, ref);
        break;
      case _MenuAction.settings:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings tapped')));
        break;
      case _MenuAction.logout:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const AnimatedShiningTitle(text: 'Job Roles'),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          actions: [
            PopupMenuButton<_MenuAction>(
              icon: const Icon(Icons.more_vert),
              onSelected: (action) => _onMenuSelected(context, ref, action),
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: _MenuAction.profile, child: ListTile(leading: Icon(Icons.person), title: Text('Profile'))),
                PopupMenuItem(value: _MenuAction.theme, child: ListTile(leading: Icon(Icons.color_lens), title: Text('Theme'))),
                PopupMenuItem(value: _MenuAction.settings, child: ListTile(leading: Icon(Icons.settings), title: Text('Settings'))),
                PopupMenuDivider(),
                PopupMenuItem(value: _MenuAction.logout, child: ListTile(leading: Icon(Icons.logout), title: Text('Logout'))),
              ],
            ),
          ],
          bottom: _currentIndex == 0
              ? const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Archived'),
            ],
          )
              : null,
        ),

        // OPTIMIZED: The main Stack separates the animated background from the static foreground
        body: Stack(
          children: [
            // 1. Animated Layer (Isolated rebuilds)
            _AnimatedBackground(controller: _backgroundController),

            // 2. Static Layer (Only rebuilds when _currentIndex changes)
            IndexedStack(
              index: _currentIndex,
              children: [
                TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                     RolesTab(archived: false),
                     RolesTab(archived: true),
                  ],
                ),
                const MessagesTab(),
                const ApplicationsTab(), // Assuming this isn't const in your actual code if it takes arguments
              ],
            ),
          ],
        ),

        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            setState(() {
              _currentIndex = i;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              label: "Jobs",
            ),
            NavigationDestination(
              icon: Icon(Icons.message_outlined),
              label: "Messages",
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_turned_in_outlined),
              label: "Applications",
            ),
          ],
        ),
      ),
    );
  }
}

// Extracting the background isolates the AnimatedBuilder cleanly
class _AnimatedBackground extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedBackground({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Animated Gradient
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1 + (controller.value * .25), -1),
                      end: Alignment(1, 1 - (controller.value * .25)),
                      colors: isDark
                          ? const [
                        Color(0xFF0B1220),
                        Color(0xFF111827),
                        Color(0xFF172554),
                      ]
                          : const [
                        Color(0xFFF2F8FF),
                        Color(0xFFEAF4FF),
                        Color(0xFFDCEEFF),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Top Glow
            Positioned(
              top: -140,
              right: -80,
              child: IgnorePointer(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(isDark ? .10 : .14),
                  ),
                ),
              ),
            ),

            // Bottom Glow
            Positioned(
              bottom: -140,
              left: -100,
              child: IgnorePointer(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.secondary.withOpacity(isDark ? .08 : .10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum _MenuAction { profile, theme, settings, logout }