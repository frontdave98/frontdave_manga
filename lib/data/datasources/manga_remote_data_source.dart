import '../models/manga_model.dart';
import '../../core/network/api_client.dart';

class MangaRemoteDataSource {
  final ApiClient client;

  MangaRemoteDataSource(this.client);

  Future<List<MangaModel>> fetchMangas() async {
    final response = await client.get('/mangas?type=all');
    return (response.data['data'] as List)
        .map((json) => MangaModel.fromJson(json))
        .toList();
  }

  Future<MangaModel> fetchMangaDetail(String slug) async {
    final response = await client.get("/mangas?type=content&slug=$slug");
    return MangaModel.fromJson(response.data['data']);
  }

  Future<MangaModel> fetchMangaContent(String slug, String url) async {
    final response =
        await client.get("/mangas?type=content-detail&slug=$slug&url=$url");

    return MangaModel.fromJson(response.data['data']);
  }
}
