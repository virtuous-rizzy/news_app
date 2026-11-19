import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/env.dart';
import '../models/article_model.dart';
import '../models/news_response_model.dart';
import '../utils/game_topics.dart';
import 'api_exception.dart';

/// URL dan API key TIDAK ditulis di sini, tetapi dibaca dari Env.
class NewsApiService {
  final Dio _dio;

  NewsApiService({Dio? dio}) : _dio = dio ?? _buatDio();

  static Dio _buatDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        // Ikut di setiap request
        queryParameters: {
          if (Env.pakaiKeyLangsung) 'apikey': Env.apiKey,
          'lang': 'id',
          'country': 'id',
          'max': 10,
        },
      ),
    );

    // Log hanya saat mode debug, API key disamarkan menjadi ***
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        logPrint: (obj) => debugPrint(Env.samarkan(obj.toString())),
      ));
    }
    return dio;
  }

  Future<List<ArticleModel>> searchNews(String keyword) {
    return _ambilArtikel('/search', {'q': keyword, 'sortby': 'publishedAt'});
  }

  /// Pencarian bebas yang tetap bertema game.
  Future<List<ArticleModel>> searchGame(String keyword) {
    return searchNews('"$keyword" AND $kKataTema');
  }

  /// Satu pintu untuk semua GET: di sinilah error diterjemahkan.
  Future<List<ArticleModel>> _ambilArtikel(
      String path, Map<String, dynamic> query) async {
    if (!Env.lengkap) {
      throw ApiException(
        'Konfigurasi belum diisi. Jalankan dengan '
        '--dart-define-from-file=config/env.json',
      );
    }
    try {
      final response = await _dio.get(path, queryParameters: query);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Format data dari server tidak dikenali.');
      }
      return NewsResponseModel.fromJson(data).articles;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } on TypeError {
      throw ApiException('Struktur data dari server berbeda dari model.');
    }
  }
}
