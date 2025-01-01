import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class MangaCard extends ConsumerWidget {
  final Manga item;
  const MangaCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 3,
              color: currentTheme == ThemeMode.light
                  ? Colors.blueAccent
                  : Colors.red),
          color:
              currentTheme == ThemeMode.light ? Colors.blueAccent : Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      child: InkWell(
        onTap: () {
          ref.read(navigationProvider.notifier).state = item.slug;
          context.push('/detail/${item.slug}');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: currentTheme == ThemeMode.light
                    ? Colors.grey[300]
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: 100, // Bounded width
              child: AspectRatio(
                aspectRatio: 9 / 13, // Example: 16:9 ratio
                child: Hero(
                  tag: item.featured_image,
                  child: CachedNetworkImage(
                    imageUrl: item.featured_image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        item.description.replaceAll('\n', ' '),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
