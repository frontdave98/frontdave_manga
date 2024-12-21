import 'package:frontdave_manga/domain/entities/manga.dart';

abstract class MangaRepository {
  Future<List<Manga>> fetchMangas();
  Future<Manga> fetchMangaDetail(String slug);
  Future<Manga> fetchMangaContent(String slug, String url);
}
