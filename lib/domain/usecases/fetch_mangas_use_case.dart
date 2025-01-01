import '../entities/manga.dart';
import '../repositories/manga_repositories.dart';

class FetchMangasUseCase {
  final MangaRepository repository;

  FetchMangasUseCase(this.repository);

  Future<List<Manga>> call() async {
    return repository.fetchMangas(false);
  }
}

class FetchHiddenMangasUseCase {
  final MangaRepository repository;

  FetchHiddenMangasUseCase(this.repository);

  Future<List<Manga>> call() async {
    return repository.fetchMangas(true);
  }
}

class FetchMangaDetailUseCase {
  final MangaRepository repository;

  FetchMangaDetailUseCase(this.repository);

  Future<Manga> call(String slug) async {
    return repository.fetchMangaDetail(slug);
  }
}

class FetchMangaContentUseCase {
  final MangaRepository repository;

  FetchMangaContentUseCase(this.repository);

  Future<Manga> call(String slug, String url) async {
    if (slug.isEmpty || url.isEmpty) {
      throw ArgumentError('Slug and URL cannot be empty.');
    }
    return repository.fetchMangaContent(slug, url);
  }
}
