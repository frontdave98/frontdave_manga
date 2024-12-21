import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';

class MainAppDetailBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  const MainAppDetailBar({super.key, this.title});

  @override
  final Size preferredSize =
      const Size.fromHeight(kToolbarHeight); // Preferred size of the app bar.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider); // Wate.
    final themeNotifier = ref.read(
        themeNotifierProvider.notifier); // Access notifier.ch the theme mode.
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent, // Dark color
                Colors.transparent, // Dark color
                Colors.transparent, // Semi-transparent
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: Text(
              title != null ? title! : '',
              style: TextStyle(
                  color: currentTheme == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
            backgroundColor:
                Colors.black.withOpacity(0), // Black with 50% opacity
            elevation: 10,
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
          )),
    );
  }
}
