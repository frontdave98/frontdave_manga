import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/screens/content_screen.dart';
import 'package:frontdave_manga/presentation/screens/detail_screen.dart';
import 'package:frontdave_manga/presentation/screens/hidden_screen.dart';
import 'package:frontdave_manga/presentation/screens/home_screen.dart';
import 'package:frontdave_manga/presentation/styles/theme.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/hidden',
      builder: (context, state) => const HiddenScreen(),
    ),
    GoRoute(
      path: '/detail/:slug',
      builder: (context, state) {
        final String? slug = state.params['slug'];
        return DetailScreen(slug: slug);
      },
    ),
    GoRoute(
      path: '/content/:slug',
      builder: (context, state) {
        final String? slug = state.params['slug'];
        return ContentScreen(
          slug: slug,
        );
      },
    ),
  ],
);

void main() {
  runApp(ProviderScope(child: MyApp(router: _router)));
}

class MyApp extends ConsumerWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'Frontdave Manga | Mini app',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeMode, // Use the current theme mode.
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
