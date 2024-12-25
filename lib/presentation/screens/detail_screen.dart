import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar_detail.dart';
import 'package:frontdave_manga/presentation/widgets/tab_bar.dart';
import 'package:go_router/go_router.dart';

class HeroImage extends StatelessWidget {
  final String featured_image;
  const HeroImage({super.key, required this.featured_image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16))),
      child: Hero(
        tag: featured_image,
        child: CachedNetworkImage(
          imageUrl: featured_image,
          fit: BoxFit.cover,
          width: double.infinity,
          errorWidget: (context, url, error) => const SizedBox(
            height: 0,
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends ConsumerWidget {
  final String? slug;
  const DetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider); // Wate.

    final mangaDetail = ref.watch(mangaDetailProvider(slug!));

    return Scaffold(
        appBar: MainAppDetailBar(title: mangaDetail.asData?.value.title),
        body: mangaDetail.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (detail) {
              return Tabs(
                tabs: const [
                  Tab(
                    child: Text('Detail'),
                  ),
                  Tab(
                    child: Text('Chapter List'),
                  ),
                ],
                tabViews: [
                  RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      // Step 3: Refetch data
                      return ref.refresh(mangaDetailProvider(slug!));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          HeroImage(
                            featured_image: detail.featured_image,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(detail.title,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 3)),
                                const SizedBox(height: 10),
                                Text(detail.description,
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Step 3: Refetch data
                        return ref.refresh(mangaDetailProvider(slug!));
                      },
                      child: SingleChildScrollView(
                          child: Column(
                              children: detail.chapters.map((ch) {
                        return InkWell(
                            onTap: () {
                              String fullUrl = detail.url;

                              // Parse the URL
                              Uri uri = Uri.parse(fullUrl);

                              // Extract the origin
                              String origin = "${uri.scheme}://${uri.host}";
                              ref.read(navigationProvider.notifier).state =
                                  ch.link.contains('http')
                                      ? ch.link
                                      : "$origin${ch.link}";
                              context.push('/content/${detail.slug}');
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border:
                                      Border(bottom: BorderSide(width: 0.3))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ch.chapter,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800)),
                                    const Icon(Icons.arrow_forward_ios)
                                  ]),
                            ));
                      }).toList())),
                    ),
                  ),
                ],
                tabBarColor: currentTheme == ThemeMode.light
                    ? Colors.white
                    : Colors.black,
                labelColor: currentTheme == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorColor: currentTheme == ThemeMode.light
                    ? Colors.black
                    : Colors.white,
                tabViewBackgroundColor: currentTheme == ThemeMode.light
                    ? Colors.white
                    : Colors.black,
              );
            }));
  }
}
