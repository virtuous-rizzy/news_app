import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';

/// Hasil pencarian (latihan di materi), juga memakai FutureBuilder.
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final NewsApiService _service = NewsApiService();
  late final String _keyword;
  late Future<List<ArticleModel>> _future;

  @override
  void initState() {
    super.initState();
    _keyword = Get.arguments as String;
    _future = _service.searchGame(_keyword);
  }

  void _muatUlang() {
    setState(() {
      _future = _service.searchGame(_keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari: $_keyword'),
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
                message: snapshot.error.toString(), onRetry: _muatUlang);
          }
          final articles = snapshot.data ?? [];
          if (articles.isEmpty) {
            return const Center(child: Text('Tidak ada hasil.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: articles.length,
            itemBuilder: (context, i) => ArticleCard(
              article: articles[i],
              onTap: () => Get.toNamed(AppRoutes.detail, arguments: articles[i]),
            ),
          );
        },
      ),
    );
  }
}
