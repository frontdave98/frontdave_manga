import '../../domain/entities/manga.dart';

class MangaModel extends Manga {
  MangaModel(
      {required super.url,
      required super.title,
      required super.description,
      required super.all_chapter_selector,
      required super.created_at,
      required super.featured_image,
      required super.image_selector,
      required super.slug,
      required super.chapters,
      required super.images});

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      all_chapter_selector: json['all_chapter_selector'] ?? '',
      created_at: json['created_at'] ?? '',
      featured_image: json['featured_image'] ?? '',
      image_selector: json['image_selector'] ?? '',
      slug: json['slug'] ?? '',
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((chapter) => ChapterList.fromJson(chapter))
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
              ?.map((chapter) => ChapterContent.fromJson(chapter))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'description': description,
      'all_chapter_selector': all_chapter_selector,
      'created_at': created_at,
      'featured_image': featured_image,
      'image_selector': image_selector,
      'slug': slug,
      'chapters': chapters,
      'images': images,
    };
  }
}
