import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/styles/design_system.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar.dart';
import 'package:frontdave_manga/presentation/widgets/manga_card.dart';
import 'package:frontdave_manga/presentation/widgets/skeleton_card.dart';
import 'package:shimmer/shimmer.dart';

final keywordProvider = StateProvider<String>((ref) => '');

class HiddenScreen extends ConsumerWidget {
  const HiddenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaState = ref.watch(hiddenMangaProvider);
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
                  return SingleChildScrollView(
                    child: Column(
                        children: List.generate(filteredMangas.length, (index) {
                      final manga = filteredMangas[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MangaCard(
                          item: manga,
                        ),
                      );
                    })),
                  );
                },
                skipLoadingOnRefresh: false,
                loading: () {
                  return ListView.builder(
                    itemCount:
                        6, // Adjust based on how many skeletons you want to show
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
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
