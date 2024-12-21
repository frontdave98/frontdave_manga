import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  final Size preferredSize =
      const Size.fromHeight(kToolbarHeight); // Preferred size of the app bar.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider); // Wate.
    final themeNotifier = ref.read(
        themeNotifierProvider.notifier); // Access notifier.ch the theme mode.

    return PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SizedBox(
          height: 120,
          child: AppBar(
            centerTitle: true,
            title: Image.asset(
              'lib/assets/app_icon.png',
              height: 25,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  themeNotifier.setThemeMode(currentTheme == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark);
                }, // Toggle theme on click.
                icon: SizedBox(
                    child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: Icon(currentTheme == ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode))),
              ),
            ],
          ),
        ));
  }
}
