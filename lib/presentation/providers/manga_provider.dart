import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontdave_manga/domain/entities/manga.dart';
import '../../domain/usecases/fetch_mangas_use_case.dart';
import '../../data/repositories/manga_repositories_impl.dart';
import '../../data/datasources/manga_remote_data_source.dart';
import '../../core/network/api_client.dart';

// Provider for API client
final apiClientProvider = Provider((ref) => ApiClient());

// Provider for remote data source
final remoteDataSourceProvider = Provider(
  (ref) => MangaRemoteDataSource(ref.read(apiClientProvider)),
);

// Provider for repository
final mangaRepositoryProvider = Provider(
  (ref) => MangaRepositoryImpl(ref.read(remoteDataSourceProvider)),
);

// ----------------------------------- USE CASE

// Provider for use case
final fetchMangasUseCaseProvider = Provider(
  (ref) => FetchMangasUseCase(ref.read(mangaRepositoryProvider)),
);
final fetchHiddenMangasUseCaseProvider = Provider(
  (ref) => FetchHiddenMangasUseCase(ref.read(mangaRepositoryProvider)),
);
final fetchMangaDetailUseCaseProvider = Provider(
  (ref) => FetchMangaDetailUseCase(ref.read(mangaRepositoryProvider)),
);
final fetchMangaContentUseCaseProvider = Provider(
  (ref) => FetchMangaContentUseCase(ref.read(mangaRepositoryProvider)),
);

// State notifier for fetching mangas
final mangaProvider = FutureProvider((ref) async {
  final useCase = ref.read(fetchMangasUseCaseProvider);
  return await useCase();
});
// State notifier for fetching mangas
final hiddenMangaProvider = FutureProvider((ref) async {
  final useCase = ref.read(fetchHiddenMangasUseCaseProvider);
  return await useCase();
});

// State notifier for fetching mangas
final mangaDetailProvider =
    FutureProvider.family<Manga, String>((ref, slug) async {
  final useCase = ref.read(fetchMangaDetailUseCaseProvider);
  return await useCase(slug);
});

// State notifier for fetching mangas
final mangaContentProvider =
    FutureProvider.family<Manga, MangaParams>((ref, params) async {
  final useCase = ref.read(fetchMangaContentUseCaseProvider);
  return await useCase(params.slug, params.url);
});
