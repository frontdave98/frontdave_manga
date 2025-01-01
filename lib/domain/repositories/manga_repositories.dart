import 'package:frontdave_manga/domain/entities/manga.dart';

abstract class MangaRepository {
  Future<List<Manga>> fetchMangas(bool? isHidden);
  Future<Manga> fetchMangaDetail(String slug);
  Future<Manga> fetchMangaContent(String slug, String url);
}
