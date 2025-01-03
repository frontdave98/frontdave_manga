import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/presentation/helpers/sound.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/styles/design_system.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar.dart';
import 'package:frontdave_manga/presentation/widgets/manga_card.dart';
import 'package:frontdave_manga/presentation/widgets/skeleton_card.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

final keywordProvider = StateProvider<String>((ref) => '');
final filterProvider = StateProvider<String>((ref) => 'All');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaState = ref.watch(mangaProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    // Watch the keyword from the StateProvider
    final filter = ref.watch(filterProvider);

    // Determine the number of columns based on screen size and orientation
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    late int crossAxisCount;
    late double childAspectRatio;
    if (isTablet) {
      crossAxisCount = isLandscape ? 3 : 2;
      childAspectRatio = isTablet ? 2 / 0.6 : 2 / 0.3;
    } else {
      crossAxisCount = isLandscape ? 2 : 1;
      childAspectRatio = isLandscape ? 2 / 0.54 : 2 / 0.58;
    }
    return Scaffold(
      appBar: const MainAppBar(),
      backgroundColor:
          currentTheme == ThemeMode.dark ? Colors.black : Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          // Step 3: Refetch data
          return ref.refresh(mangaProvider);
        },
        child: SafeArea(
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
              Row(children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Search Manga',
                      fillColor: currentTheme == ThemeMode.light
                          ? Colors.grey[200]
                          : Colors.grey[900],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: currentTheme == ThemeMode.light
                              ? Colors.grey[900]
                              : Colors.grey[200]),
                      prefixIcon: const Icon(
                        Icons.search,
                        size: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      constraints:
                          BoxConstraints.loose(const Size(double.infinity, 40)),
                      contentPadding: const EdgeInsets.all(8.0),
                    ),
                    onChanged: (value) {
                      // Update the keyword
                      if (value == 'hesoyam') {
                        playSound();

                        ref.read(keywordProvider.notifier).state = '';
                        ref
                            .read(themeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.dark);

                        // Show the SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: currentTheme == ThemeMode.light
                                ? Colors.white
                                : Colors.black,
                            content: Text(
                              'Navigating to hidden route...',
                              style: TextStyle(
                                  color: currentTheme == ThemeMode.light
                                      ? Colors.blue
                                      : Colors.red),
                            ),
                            duration: const Duration(
                                seconds: 2), // Adjust the duration as needed
                          ),
                        );

                        // Delay the navigation to allow the SnackBar to be visible
                        context.push('/hidden');
                      }
                      ref.read(keywordProvider.notifier).state = value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                SizedBox(
                  width: 80,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      padding: EdgeInsets.zero,
                      value: ref.read(filterProvider.notifier).state,
                      isDense: true,
                      isExpanded: true,
                      icon: const Icon(Icons.filter_list),
                      items: <String>['All', 'A-Z', 'Z-A', 'Latest', 'Newest']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Handle filter change
                        ref.read(filterProvider.notifier).state = newValue!;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ]),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: mangaState.when(
                  data: (mangas) {
                    final keyword = ref.watch(keywordProvider);
                    final filteredMangas = mangas.where((manga) {
                      final matchesKeyword = manga.title
                          .toLowerCase()
                          .contains(keyword.toLowerCase());
                      return matchesKeyword;
                    }).toList();

                    // Sort mangas based on the selected filter
                    if (filter == 'A-Z') {
                      filteredMangas.sort((a, b) => a.title.compareTo(b.title));
                    } else if (filter == 'Z-A') {
                      filteredMangas.sort((a, b) => b.title.compareTo(a.title));
                    } else if (filter == 'Latest') {
                      filteredMangas
                          .sort((a, b) => a.created_at.compareTo(b.created_at));
                    } else if (filter == 'Newest') {
                      filteredMangas
                          .sort((a, b) => b.created_at.compareTo(a.created_at));
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: filteredMangas.length,
                        itemBuilder: (context, index) {
                          final manga = filteredMangas[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 0),
                            child: MangaCard(
                              item: manga,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  skipLoadingOnRefresh: false,
                  loading: () {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 16,
                      ),
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
                  error: (error, stack) => Column(children: [
                    Text('Error: $error'),
                    ElevatedButton(
                        onPressed: () {
                          ref.refresh(mangaProvider);
                        },
                        child: const Text('Refresh'))
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
