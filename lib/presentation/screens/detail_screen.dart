import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/last_read_chapter_provider.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar_detail.dart';
import 'package:frontdave_manga/presentation/widgets/tab_bar.dart';
import 'package:go_router/go_router.dart';

class HeroImage extends StatelessWidget {
  final String featured_image;
  final ThemeMode theme;
  const HeroImage(
      {super.key, required this.featured_image, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      width: double.infinity,
      decoration: BoxDecoration(
          color: theme == ThemeMode.light ? Colors.blue : Colors.redAccent,
          border: Border.all(
              width: 8,
              color: theme == ThemeMode.light ? Colors.blue : Colors.redAccent),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16))),
      child: Hero(
        tag: featured_image,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: CachedNetworkImage(
            imageUrl: featured_image,
            fit: BoxFit.cover,
            width: double.infinity,
            errorWidget: (context, url, error) => const SizedBox(
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class LastChapter extends ConsumerWidget {
  final Manga detail;
  final String lastChapterDetail;
  const LastChapter(
      {super.key, required this.lastChapterDetail, required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> chapterMap = jsonDecode(lastChapterDetail);
    final currentTheme = ref.watch(themeNotifierProvider); // Wate.

    // Create a ChapterList instance from the decoded JSON map
    final ChapterList chapter = ChapterList.fromJson(chapterMap);

    return InkWell(
      onTap: () {
        String fullUrl = detail.url;

        // Parse the URL
        Uri uri = Uri.parse(fullUrl);

        // Extract the origin
        String origin = "${uri.scheme}://${uri.host}";
        ref.read(navigationProvider.notifier).state =
            chapter.link.contains('http')
                ? chapter.link
                : "$origin${chapter.link}";
        context.push('/content/${detail.slug}');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        color: currentTheme == ThemeMode.light
            ? Colors.blue.withOpacity(0.6)
            : Colors.redAccent.withOpacity(0.6),
        child: Center(
          child: Text(
            'Last Read: ${chapter.chapter}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

    final lastReadChapter = ref.watch(lastReadChapterProvider);
    final notifier = ref.read(lastReadChapterProvider.notifier);

    // Load the last read chapter for the manga
    notifier.loadLastReadChapter(slug!);
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
                            theme: currentTheme,
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
                  RefreshIndicator(
                    onRefresh: () async {
                      // Step 3: Refetch data
                      return ref.refresh(mangaDetailProvider(slug!));
                    },
                    child: SingleChildScrollView(
                        child: Column(children: [
                      if (lastReadChapter != null)
                        LastChapter(
                          detail: detail,
                          lastChapterDetail: lastReadChapter,
                        ),
                      ...detail.chapters.map((ch) {
                        return InkWell(
                            onTap: () async {
                              await notifier.setLastReadChapter(slug!, ch);

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
                      }).toList()
                    ])),
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
