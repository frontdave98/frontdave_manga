import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/last_read_chapter_provider.dart';
import 'package:frontdave_manga/presentation/providers/manga_provider.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:frontdave_manga/presentation/widgets/app_bar_detail.dart';
import 'package:go_router/go_router.dart';

final drawerVisibilityProvider = StateProvider<bool>((ref) => false);
final targetIndexProvider = StateProvider<int?>((ref) => null);

class MangaImage extends StatelessWidget {
  final String image_url;
  final VoidCallback onTap;
  const MangaImage({super.key, required this.image_url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true, // Enables panning
      minScale: 1.0, // Minimum zoom scale
      maxScale: 5.0, // Maximum zoom scale
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: CachedNetworkImage(
          imageUrl: image_url,
          width: double.infinity,
          errorWidget: (context, url, error) => const SizedBox(
            height: 0,
          ),
        ),
      ),
    );
  }
}

Widget bottomDrawer(BuildContext context, WidgetRef ref, Manga? item,
    String? url, bool isDrawerVisible) {
  final currentTheme = ref.watch(themeNotifierProvider);
  final lastReadChapter = ref.watch(lastReadChapterProvider);
  final notifier = ref.read(lastReadChapterProvider.notifier);

  // Load the last read chapter for the manga

  if (item == null) {
    return const SizedBox(
      height: 0,
    );
  }
  notifier.loadLastReadChapter(item.slug);
  final mangaDetail = ref.watch(mangaDetailProvider(item.slug));

  String? fullUrl = mangaDetail.asData?.value.url;

  // Parse the URL
  String origin = '';
  if (fullUrl != null) {
    Uri uri = Uri.parse(fullUrl);
    // Extract the origin
    origin = "${uri.scheme}://${uri.host}";
  }

  final ScrollController scrollController = ScrollController();
// Check the condition when the state changes
  // Listen to changes in the target index provider

  final currentChapterIndex = mangaDetail.asData?.value.chapters.indexWhere(
      (item) =>
          (item.link.contains('http') ? item.link : "$origin${item.link}") ==
          url);
  final prevChapter = currentChapterIndex! >= 0 &&
          currentChapterIndex <
              (mangaDetail.asData?.value.chapters.length ?? 0) - 1
      ? mangaDetail.asData?.value.chapters[currentChapterIndex + 1]
      : null;
  final nextChapter = currentChapterIndex > 0
      ? mangaDetail.asData?.value.chapters[currentChapterIndex - 1]
      : null;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (currentChapterIndex != null) {
      scrollController.animateTo(
        currentChapterIndex * 40.0, // Assuming each item is 60.0 pixels high
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  });
  return AnimatedContainer(
    color: currentTheme == ThemeMode.dark ? Colors.black : Colors.white,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    height: isDrawerVisible ? 350 : 0,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: currentTheme == ThemeMode.dark
                ? Colors.redAccent
                : Colors.blueAccent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  ref.read(drawerVisibilityProvider.notifier).state = false;
                  context.replace('/detail/${item.slug}');
                },
                child: const Icon(Icons.arrow_back),
              ),
              InkWell(
                splashColor: Colors.white,
                onTap: () async {
                  if (prevChapter != null) {
                    String alteredLink = prevChapter.link.contains('http')
                        ? prevChapter.link
                        : "$origin${prevChapter.link}";
                    ref.read(navigationProvider.notifier).state = alteredLink;
                    ref.read(drawerVisibilityProvider.notifier).state = false;
                    await notifier.setLastReadChapter(item.slug, prevChapter);
                    context.replace('/content/${item.slug}');
                  }
                },
                child: const Icon(Icons.keyboard_double_arrow_left_outlined),
              ),
              InkWell(
                onTap: () async {
                  if (nextChapter != null) {
                    String alteredLink = nextChapter.link.contains('http')
                        ? nextChapter.link
                        : "$origin${nextChapter.link}";
                    ref.read(navigationProvider.notifier).state = alteredLink;
                    ref.read(drawerVisibilityProvider.notifier).state = false;
                    await notifier.setLastReadChapter(item.slug, nextChapter);
                    context.replace('/content/${item.slug}');
                  }
                },
                child: const Icon(Icons.keyboard_double_arrow_right_outlined),
              ),
              InkWell(
                onTap: () {
                  ref.read(drawerVisibilityProvider.notifier).state = false;
                },
                child: const Icon(Icons.close),
              )
            ],
          ),
        ),
        Expanded(
          child: mangaDetail.when(
              data: (detail) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      children: detail.chapters.map((ch) {
                    String alteredLink = ch.link.contains('http')
                        ? ch.link
                        : "$origin${ch.link}";
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: alteredLink == url
                              ? currentTheme == ThemeMode.dark
                                  ? Colors.red
                                  : Colors.black
                              : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      child: InkWell(
                        onTap: () async {
                          ref.read(navigationProvider.notifier).state =
                              alteredLink;
                          ref.read(drawerVisibilityProvider.notifier).state =
                              false;
                          await notifier.setLastReadChapter(detail.slug, ch);

                          context.push('/content/${detail.slug}');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ch.chapter,
                              style: TextStyle(
                                fontSize: 16,
                                color: alteredLink == url
                                    ? Colors.white
                                    : currentTheme == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: alteredLink == url
                                  ? Colors.white
                                  : currentTheme == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()),
                );
              },
              loading: () => const SizedBox(height: 0),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error'))),
        )
      ],
    ),
  );
}

class ContentScreen extends ConsumerWidget {
  final String? slug;
  const ContentScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaUrl = ref.watch(navigationProvider);
    final isDrawerVisible = ref.watch(drawerVisibilityProvider);

    final mangaContent = ref
        .watch(mangaContentProvider(MangaParams(slug: slug!, url: mangaUrl!)));
    final mangaDetail = ref.watch(mangaDetailProvider(slug!));

    void showListChapter() {
      ref.read(drawerVisibilityProvider.notifier).state = !isDrawerVisible;
    }

    String? fullUrl = mangaDetail.asData?.value.url;

    // Parse the URL
    Uri uri = Uri.parse(fullUrl!);

    // Extract the origin
    String origin = "${uri.scheme}://${uri.host}";

    return Scaffold(
        appBar: MainAppDetailBar(
            title: mangaDetail.asData?.value.chapters
                .where((item) {
                  String altered = (item.link.contains('http')
                      ? item.link
                      : "$origin${item.link}");
                  return altered == mangaUrl;
                })
                .first
                .chapter),
        resizeToAvoidBottomInset: true,
        bottomSheet: bottomDrawer(context, ref, mangaContent.asData?.value,
            mangaUrl, isDrawerVisible),
        body: mangaContent.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: Text('Please Wait ...')),
          error: (error, stackTrace) => Center(
              child: Column(
            children: [
              Text('Error: $error'),
              ElevatedButton.icon(
                  onPressed: () {
                    return ref.refresh(mangaContentProvider(
                        MangaParams(slug: slug!, url: mangaUrl)));
                  },
                  label: const Text('Reload'))
            ],
          )),
          data: (detail) {
            return RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                // Step 3: Refetch data
                return ref.refresh(mangaContentProvider(
                    MangaParams(slug: slug!, url: mangaUrl)));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: detail.images.map((item) {
                    return MangaImage(
                        image_url: item.image_url,
                        onTap: () {
                          showListChapter();
                        });
                  }).toList(),
                ),
              ),
            );
          },
        ));
  }
}
