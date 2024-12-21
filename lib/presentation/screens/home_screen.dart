import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar.dart';
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
          color:
              currentTheme == ThemeMode.light ? Colors.blueAccent : Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          ref.read(navigationProvider.notifier).state = item.slug;
          context.push('/detail/${item.slug}');
        },
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 260,
              width: double.infinity,
              child: Hero(
                tag: item.featured_image,
                child: CachedNetworkImage(
                  imageUrl: item.featured_image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 0,
                  ),
                ),
              ),
            ),
            Padding(
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
                      item.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaState = ref.watch(mangaProvider);

    return Scaffold(
      appBar: const MainAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Step 3: Refetch data
          return ref.refresh(mangaProvider);
        },
        child: mangaState.when(
          data: (mangas) => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: mangas.length,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MangaCard(
                  item: manga,
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
