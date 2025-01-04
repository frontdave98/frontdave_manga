import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/last_read_chapter_provider.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/styles/design_system.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar_detail.dart';
import 'package:frontdave_manga/presentation/widgets/tab_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ContentSkeleton extends ConsumerWidget {
  const ContentSkeleton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: currentTheme == ThemeMode.light ? Colors.white : Colors.black,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(2, (index) {
              return Shimmer(
                gradient: DesignSystem.skeletonGradient(
                    currentTheme == ThemeMode.light
                        ? Colors.grey[300]!
                        : Colors.grey[900]!,
                    currentTheme == ThemeMode.light
                        ? Colors.grey[500]!
                        : Colors.grey[900]!),
                child: Container(
                  height: 17,
                  width: 100,
                  decoration: BoxDecoration(
                    color: currentTheme == ThemeMode.light
                        ? Colors.grey[300]
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 300,
          child: Stack(
            children: [
              Shimmer(
                gradient: DesignSystem.skeletonGradient(
                    currentTheme == ThemeMode.light
                        ? Colors.grey[300]!
                        : Colors.grey[900]!,
                    currentTheme == ThemeMode.light
                        ? Colors.grey[300]!
                        : Colors.grey[900]!),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: currentTheme == ThemeMode.light
                        ? Colors.grey[300]
                        : Colors.grey[900],
                  ),
                ),
              ),
              Positioned(
                  child: Shimmer(
                gradient: DesignSystem.skeletonGradient(
                    currentTheme == ThemeMode.light
                        ? Colors.blueGrey[300]!
                        : Colors.blueGrey[900]!,
                    currentTheme == ThemeMode.light
                        ? Colors.blueGrey[300]!
                        : Colors.blueGrey[900]!),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: 150,
                    height: 220,
                    decoration: BoxDecoration(
                      color: currentTheme == ThemeMode.light
                          ? Colors.blueGrey[300]
                          : Colors.blueGrey[900],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Shimmer(
            gradient: DesignSystem.skeletonGradient(
                currentTheme == ThemeMode.light
                    ? Colors.grey[300]!
                    : Colors.grey[900]!,
                currentTheme == ThemeMode.light
                    ? Colors.grey[500]!
                    : Colors.grey[900]!),
            child: Container(
              height: 17,
              width: 140,
              decoration: BoxDecoration(
                color: currentTheme == ThemeMode.light
                    ? Colors.grey[300]
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer(
                  gradient: DesignSystem.skeletonGradient(
                      currentTheme == ThemeMode.light
                          ? Colors.grey[300]!
                          : Colors.grey[900]!,
                      currentTheme == ThemeMode.light
                          ? Colors.grey[500]!
                          : Colors.grey[900]!),
                  child: Container(
                    height: 32,
                    width: 180,
                    decoration: BoxDecoration(
                      color: currentTheme == ThemeMode.light
                          ? Colors.grey[300]
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(3, (index) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Shimmer(
                        gradient: DesignSystem.skeletonGradient(
                            currentTheme == ThemeMode.light
                                ? Colors.grey[300]!
                                : Colors.grey[900]!,
                            currentTheme == ThemeMode.light
                                ? Colors.grey[500]!
                                : Colors.grey[900]!),
                        child: Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: currentTheme == ThemeMode.light
                                ? Colors.grey[300]
                                : Colors.grey[900],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        )
      ],
    );
  }
}

class HeroImage extends ConsumerWidget {
  final String featured_image;
  final ThemeMode theme;
  const HeroImage(
      {super.key, required this.featured_image, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 220,
            clipBehavior: Clip.hardEdge,
            width: double.infinity,
            decoration: BoxDecoration(
                color: currentTheme == ThemeMode.light
                    ? Colors.white
                    : Colors.black,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16))),
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: ImageFiltered(
                enabled: true,
                imageFilter: ImageFilter.blur(
                    sigmaX: 5, sigmaY: 5, tileMode: TileMode.repeated),
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
          ),
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 24),
                width: 150,
                height: 220,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: currentTheme == ThemeMode.light
                        ? Colors.blue.withOpacity(0.6)
                        : Colors.redAccent.withOpacity(0.6), // Shadow color
                    spreadRadius: 5, // How wide the shadow spreads
                    blurRadius: 10, // How soft the shadow appears
                    offset: const Offset(0, 4), // Position of the shadow (x, y)
                  ),
                ], borderRadius: const BorderRadius.all(Radius.circular(16))),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LastChapter extends ConsumerWidget {
  final Manga detail;
  final String lastChapterDetail;
  final bool isDetail;
  const LastChapter(
      {super.key,
      required this.lastChapterDetail,
      required this.detail,
      required this.isDetail});

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
        padding: EdgeInsets.all(isDetail ? 16 : 8.0),
        decoration: BoxDecoration(
            color: currentTheme == ThemeMode.light
                ? Colors.blue.withOpacity(isDetail ? 0.6 : 1)
                : Colors.redAccent.withOpacity(isDetail ? 0.6 : 1),
            borderRadius: BorderRadius.all(Radius.circular(isDetail ? 16 : 0))),
        child: Row(
          mainAxisAlignment: isDetail
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Text(
              'Last Read: ',
              style: TextStyle(
                  fontSize: 14, color: isDetail ? null : Colors.white),
            ),
            Text(
              chapter.chapter,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDetail ? null : Colors.white),
            ),
          ],
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
            skipLoadingOnRefresh: false,
            loading: () => const ContentSkeleton(),
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
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: SizedBox(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${detail.chapters.length.toString()} Chapter Scrapped ",
                                    style: TextStyle(
                                        color: currentTheme == ThemeMode.light
                                            ? Colors.blueAccent
                                            : Colors.redAccent,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  )
                                ],
                              ))),
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
                          if (lastReadChapter != null)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: LastChapter(
                                  lastChapterDetail: lastReadChapter,
                                  detail: detail,
                                  isDetail: true),
                            )
                        ],
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      // Step 3: Refetch data
                      return ref.refresh(mangaDetailProvider(slug!));
                    },
                    child: Column(
                      children: [
                        if (lastReadChapter != null)
                          LastChapter(
                            detail: detail,
                            lastChapterDetail: lastReadChapter,
                            isDetail: false,
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: detail.chapters.length,
                            itemBuilder: (context, index) {
                              final ch = detail.chapters[index];
                              return InkWell(
                                splashColor: Colors.red,
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
                                  decoration: BoxDecoration(
                                    color: currentTheme == ThemeMode.light
                                        ? Colors.white
                                        : Colors.black,
                                    border: const Border(
                                        bottom: BorderSide(width: 0.3)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 14),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ch.chapter,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
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
