class ChapterList {
  final String chapter;
  final String link;
  ChapterList({required this.chapter, required this.link});

  factory ChapterList.fromJson(Map<String, dynamic> json) {
    return ChapterList(
      chapter: json['chapter'],
      link: json['link'],
    );
  }
}

class ChapterContent {
  final String image_url;
  ChapterContent({required this.image_url});

  factory ChapterContent.fromJson(Map<String, dynamic> json) {
    return ChapterContent(
      image_url: json['image_url'],
    );
  }
}

class MangaParams {
  final String slug;
  final String url;

  MangaParams({required this.slug, required this.url});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaParams && slug == other.slug && url == other.url;

  @override
  int get hashCode => slug.hashCode ^ url.hashCode;
}

class Manga {
  final String title;
  final String slug;
  final String description;
  final String url;
  final String image_selector;
  final String all_chapter_selector;
  final String created_at;
  final String featured_image;
  final List<ChapterList> chapters;
  final List<ChapterContent> images;

  Manga(
      {required this.title,
      required this.slug,
      required this.description,
      required this.url,
      required this.all_chapter_selector,
      required this.featured_image,
      required this.image_selector,
      required this.created_at,
      required this.chapters,
      required this.images});
}
