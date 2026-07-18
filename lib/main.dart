import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/roles_list_screen.dart';
import 'providers/theme_provider.dart';
import 'theme/themes.dart';
import 'data/api_client/api_clients.dart';
import 'data/repositories/roles_repository_impl.dart';
import 'providers/roles_notifier.dart';

void main() {
  final dio = Dio();
  final apiClient = ApiClient(dio);
  final repo = RolesRepositoryImpl(apiClient);

  runApp(ProviderScope(overrides: [
    rolesRepositoryProvider.overrideWithValue(repo),

  ], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Job Listing App',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme(),
      darkTheme: AppThemes.darkTheme(),
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const SplashScreen(nextRoute: '/roles', duration: Duration(milliseconds: 3500)),
        '/roles': (ctx) => const RolesListScreen(),
      },
    );
  }
}
