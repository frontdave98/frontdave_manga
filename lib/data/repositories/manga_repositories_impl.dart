import '../../domain/entities/manga.dart';
import '../../domain/repositories/manga_repositories.dart';
import '../datasources/manga_remote_data_source.dart';

class MangaRepositoryImpl implements MangaRepository {
  final MangaRemoteDataSource remoteDataSource;

  MangaRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Manga>> fetchMangas() async {
    return remoteDataSource.fetchMangas();
  }

  @override
  Future<Manga> fetchMangaDetail(String slug) async {
    return remoteDataSource.fetchMangaDetail(slug);
  }

  @override
  Future<Manga> fetchMangaContent(String slug, String url) async {
    return remoteDataSource.fetchMangaContent(slug, url);
  }
}
