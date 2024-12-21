import 'dart:convert';

import 'package:dio/dio.dart';

class ApiClient {
  late final String basicAuth;
  late final Map<String, String> headers;
  late final Dio dio;

  ApiClient() {
    basicAuth =
        'Basic ${base64Encode(utf8.encode('davarizqi@gmail.com:ilovecoffee123!'))}';
    headers = {'Authorization': basicAuth};

    dio = Dio(BaseOptions(
      baseUrl: 'https://frontdave.vercel.app/api/v1',
      headers: headers,
    ));
  }

  Future<Response> get(String path) async {
    return dio.get(path);
  }
}
