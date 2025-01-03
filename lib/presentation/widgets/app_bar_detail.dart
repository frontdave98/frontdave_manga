import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/styles/design_system.dart';
import 'package:shimmer/shimmer.dart';

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
      child: AppBar(
        title: title != null
            ? Text(
                title!,
                style: TextStyle(
                    color: currentTheme == ThemeMode.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900),
              )
            : Shimmer(
                enabled: true,
                loop: 10,
                gradient: DesignSystem.skeletonGradient(
                    currentTheme == ThemeMode.light
                        ? Colors.grey[300]!
                        : Colors.grey[900]!,
                    currentTheme == ThemeMode.light
                        ? Colors.grey[300]!
                        : Colors.grey[900]!),
                child: Container(
                    height: 16,
                    width: 100,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: currentTheme == ThemeMode.light
                          ? Colors.grey[300]
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ),
        centerTitle: true,
        backgroundColor:
            currentTheme == ThemeMode.dark ? Colors.black : Colors.white,
        elevation: 0,
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
    );
  }
}
