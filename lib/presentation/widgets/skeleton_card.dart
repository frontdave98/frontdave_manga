import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/styles/design_system.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonCard extends ConsumerWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Shimmer(
      gradient: DesignSystem.skeletonGradient(
          currentTheme == ThemeMode.light
              ? Colors.grey[300]!
              : Colors.grey[900]!,
          currentTheme == ThemeMode.light
              ? Colors.grey[300]!
              : Colors.grey[900]!),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: currentTheme == ThemeMode.light
              ? Colors.grey[300]
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 8),
            Container(
                height: 20,
                width: 120,
                color: currentTheme == ThemeMode.light
                    ? Colors.grey[300]
                    : Colors.grey[900]),
            const SizedBox(height: 4),
            Container(
                height: 16,
                width: 80,
                color: currentTheme == ThemeMode.light
                    ? Colors.grey[300]
                    : Colors.grey[900]),
          ],
        ),
      ),
    );
  }
}
