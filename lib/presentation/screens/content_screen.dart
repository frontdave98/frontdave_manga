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
import 'dart:async';

final drawerVisibilityProvider = StateProvider<bool>((ref) => false);
final targetIndexProvider = StateProvider<int?>((ref) => null);
final scrollProgressProvider = StateProvider<double>((ref) => 0.0);

class MangaImage extends StatelessWidget {
  final String image_url;
  final VoidCallback onTap;
  const MangaImage({super.key, required this.image_url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InteractiveViewer(
        panEnabled: true, // Enables panning
        minScale: 1.0, // Minimum zoom scale
        maxScale: 5.0, // Maximum zoom scale
        child: GestureDetector(
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
      ),
    );
  }
}

Widget bottomDrawer(BuildContext context, WidgetRef ref, Manga? item,
    String? url, bool isDrawerVisible, Widget slider) {
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
    scrollController.animateTo(
      currentChapterIndex * 40.0, // Assuming each item is 60.0 pixels high
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  });
  return AnimatedContainer(
    color: currentTheme == ThemeMode.dark ? Colors.black : Colors.white,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    height: isDrawerVisible ? 350 : 0,
    child: Column(
      children: [
        slider,
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
                return ListView.builder(
                  itemCount: detail.chapters.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: detail.chapters[index].link == url
                              ? currentTheme == ThemeMode.dark
                                  ? Colors.red
                                  : Colors.black
                              : Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      child: InkWell(
                        onTap: () async {
                          String alteredLink =
                              detail.chapters[index].link.contains('http')
                                  ? detail.chapters[index].link
                                  : "$origin${detail.chapters[index].link}";
                          ref.read(navigationProvider.notifier).state =
                              alteredLink;
                          ref.read(drawerVisibilityProvider.notifier).state =
                              false;
                          await notifier.setLastReadChapter(
                              detail.slug, detail.chapters[index]);

                          context.replace('/content/${detail.slug}');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detail.chapters[index].chapter,
                              style: TextStyle(
                                fontSize: 16,
                                color: detail.chapters[index].link == url
                                    ? Colors.white
                                    : currentTheme == ThemeMode.dark
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: detail.chapters[index].link == url
                                  ? Colors.white
                                  : currentTheme == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
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

class ContentScreen extends ConsumerStatefulWidget {
  final String? slug;
  const ContentScreen({super.key, required this.slug});

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _throttleTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_throttleUpdateScrollProgress);
  }

  void _throttleUpdateScrollProgress() {
    if (_throttleTimer?.isActive ?? false) return;

    _throttleTimer = Timer(const Duration(milliseconds: 1000), () {
      ref.read(scrollProgressProvider.notifier).state =
          _scrollController.position.pixels /
              _scrollController.position.maxScrollExtent;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_throttleUpdateScrollProgress);
    _scrollController.dispose();
    _throttleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mangaUrl = ref.watch(navigationProvider);
    final isDrawerVisible = ref.watch(drawerVisibilityProvider);
    final scrollProgress = ref.watch(scrollProgressProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    final mangaContent = ref.watch(
        mangaContentProvider(MangaParams(slug: widget.slug!, url: mangaUrl!)));
    final mangaDetail = ref.watch(mangaDetailProvider(widget.slug!));

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
        bottomSheet: bottomDrawer(
          context,
          ref,
          mangaContent.asData?.value,
          mangaUrl,
          isDrawerVisible,
          Slider(
            value: scrollProgress,
            thumbColor:
                currentTheme == ThemeMode.light ? Colors.blue : Colors.red,
            activeColor:
                currentTheme == ThemeMode.light ? Colors.blue : Colors.red,
            onChanged: (value) {
              final position =
                  value * _scrollController.position.maxScrollExtent;
              _scrollController.jumpTo(position);
              ref.read(scrollProgressProvider.notifier).state = value;
            },
          ),
        ),
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
                        MangaParams(slug: widget.slug!, url: mangaUrl)));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload'))
            ],
          )),
          data: (detail) {
            return RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                return ref.refresh(mangaContentProvider(
                    MangaParams(slug: widget.slug!, url: mangaUrl)));
              },
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: scrollProgress,
                    backgroundColor: Colors.grey[200],
                    color: currentTheme == ThemeMode.light
                        ? const Color.fromARGB(255, 230, 239, 246)
                        : Colors.red,
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: detail.images.length,
                      itemBuilder: (context, index) {
                        return MangaImage(
                            image_url: detail.images[index].image_url,
                            onTap: () {
                              showListChapter();
                            });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
