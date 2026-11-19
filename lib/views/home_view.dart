import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../utils/game_topics.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();

  String _selectedCategory = 'Semua';

  /// Untuk tombol panah geser chip kiri/kanan
  final ScrollController _chipController = ScrollController();

  /// Future disimpan di State, BUKAN dibuat di dalam build()
  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _service.searchNews(kTopikGame[_selectedCategory]!);
    // Setelah layout pertama, tombol panah perlu tahu apakah chip meluap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _chipController.dispose();
    super.dispose();
  }

  void _geserChip(double delta) {
    if (!_chipController.hasClients) return;
    final target = (_chipController.offset + delta)
        .clamp(0.0, _chipController.position.maxScrollExtent);
    _chipController.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// Future baru -> FutureBuilder otomatis memulai ulang.
  /// Pakai blok { }, bukan arrow (jebakan no. 2 di materi).
  void _muatUlang() {
    setState(() {
      _futureNews = _service.searchNews(kTopikGame[_selectedCategory]!);
    });
  }

  void _gantiKategori(String category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    _muatUlang();
  }

  /// Untuk RefreshIndicator: tunggu sampai request selesai
  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _futureNews;
    } catch (_) {
      // error sudah ditampilkan oleh FutureBuilder
    }
  }

  Future<void> _bukaDialogCari() async {
    final controller = TextEditingController();
    final keyword = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cari Berita'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Cari berita game...'),
          onSubmitted: (v) => Navigator.of(ctx).pop(v),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: const Text('Cari')),
        ],
      ),
    );
    controller.dispose();
    if (keyword != null && keyword.trim().isNotEmpty) {
      Get.toNamed(AppRoutes.search, arguments: keyword.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game News'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _bukaDialogCari),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: FutureBuilder<List<ArticleModel>>(
              future: _futureNews,
              builder: (context, snapshot) {
                // Urutan: menunggu -> error -> kosong -> data
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _muatUlang,
                  );
                }
                final articles = snapshot.data ?? [];
                if (articles.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(
                            child:
                                Text('Belum ada berita game untuk topik ini.')),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () =>
                            Get.toNamed(AppRoutes.detail, arguments: article),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return AnimatedBuilder(
      animation: _chipController,
      builder: (context, _) {
        final siap = _chipController.hasClients &&
            _chipController.position.hasContentDimensions;
        final bisaKiri = siap && _chipController.offset > 0;
        final bisaKanan = !siap ||
            _chipController.offset <
                _chipController.position.maxScrollExtent - 1;

        return Container(
          height: 56,
          color: AppColors.background,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Geser kiri',
                icon: const Icon(Icons.chevron_left, color: AppColors.secondary),
                onPressed: bisaKiri ? () => _geserChip(-200) : null,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _chipController,
                  scrollDirection: Axis.horizontal,
                  itemCount: kTopikGame.length,
                  itemBuilder: (context, index) {
                    final category = kTopikGame.keys.elementAt(index);
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: category == _selectedCategory,
                        onSelected: (_) => _gantiKategori(category),
                        backgroundColor: AppColors.accent,
                        selectedColor: AppColors.secondary,
                        checkmarkColor: Colors.white,
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: category == _selectedCategory
                              ? Colors.white
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                tooltip: 'Geser kanan',
                icon: const Icon(Icons.chevron_right, color: AppColors.secondary),
                onPressed: bisaKanan ? () => _geserChip(200) : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
