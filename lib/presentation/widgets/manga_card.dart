import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import 'package:frontdave_manga/presentation/providers/providers.dart';
import 'package:frontdave_manga/presentation/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class MangaCard extends ConsumerStatefulWidget {
  final Manga item;
  const MangaCard({
    super.key,
    required this.item,
  });

  @override
  _MangaCardState createState() => _MangaCardState();
}

class _MangaCardState extends ConsumerState<MangaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: currentTheme == ThemeMode.light
                      ? Colors.blueAccent
                      : Colors.red,
                ),
                color: currentTheme == ThemeMode.light
                    ? Colors.blueAccent
                    : Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: InkWell(
                onTap: () {
                  ref.read(navigationProvider.notifier).state =
                      widget.item.slug;
                  context.push('/detail/${widget.item.slug}');
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
                      width: 60, // Bounded width
                      child: AspectRatio(
                        aspectRatio: 9 / 13, // Example: 16:9 ratio
                        child: Hero(
                          tag: widget.item.featured_image,
                          child: CachedNetworkImage(
                            imageUrl: widget.item.featured_image,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const SizedBox(
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
                              widget.item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                                decoration: TextDecoration.none,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.item.description.replaceAll('\n', ' '),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
