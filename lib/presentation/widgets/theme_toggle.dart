import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  static const _menuItems = [
    PopupMenuItem(value: ThemeMode.system, child: Text('System default')),
    PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
    PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilding when the theme actually changes
    final mode = ref.watch(themeNotifierProvider);

    return PopupMenuButton<ThemeMode>(
      icon: Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
      onSelected: (m) => ref.read(themeNotifierProvider.notifier).setTheme(m),
      itemBuilder: (_) => _menuItems,
      tooltip: 'Theme',
    );
  }
}