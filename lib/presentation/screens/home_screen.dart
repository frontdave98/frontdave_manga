import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/styles/design_system.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

final keywordProvider = StateProvider<String>((ref) => '');

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
                      maxLines: 3,
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

class SkeletonCard extends ConsumerWidget {
  const SkeletonCard({Key? key}) : super(key: key);

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
              height: 200,
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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaState = ref.watch(mangaProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    // Watch the keyword from the StateProvider
    final keyword = ref.watch(keywordProvider);

    return Scaffold(
      appBar: const MainAppBar(),
      backgroundColor:
          currentTheme == ThemeMode.dark ? Colors.black : Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // Step 3: Refetch data
          return ref.refresh(mangaProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: (mangaState.isLoading ||
                        mangaState.isRefreshing ||
                        mangaState.isReloading)
                    ? Shimmer(
                        gradient: DesignSystem.skeletonGradient(
                            currentTheme == ThemeMode.light
                                ? Colors.grey[300]!
                                : Colors.grey[900]!,
                            currentTheme == ThemeMode.light
                                ? Colors.grey[300]!
                                : Colors.grey[900]!),
                        child: Container(
                          height: 17,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Text(
                            "${mangaState.asData?.value.length} Manga Scrapped",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: currentTheme == ThemeMode.light
                                  ? Colors.blueAccent
                                  : Colors.redAccent,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            size: 16,
                            Icons.check_circle,
                            color: Colors.greenAccent,
                          )
                        ],
                      )),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Search Manga',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none),
              onChanged: (value) {
                // Update the keyword
                ref.read(keywordProvider.notifier).state = value;
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: mangaState.when(
                data: (mangas) {
                  // Filter mangas based on the keyword
                  final filteredMangas = mangas
                      .where((manga) => manga.title
                          .toLowerCase()
                          .contains(keyword.toLowerCase()))
                      .toList();
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredMangas.length,
                    itemBuilder: (context, index) {
                      final manga = filteredMangas[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MangaCard(
                          item: manga,
                        ),
                      );
                    },
                  );
                },
                skipLoadingOnRefresh: false,
                loading: () {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount:
                        6, // Adjust based on how many skeletons you want to show
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SkeletonCard(),
                      );
                    },
                  );
                },
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
