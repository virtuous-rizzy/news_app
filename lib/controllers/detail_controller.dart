import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';

class DetailController extends GetxController {
  late final ArticleModel article;

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as ArticleModel;
  }

  Future<void> salinLink() async {
    final url = article.url;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar('Tersalin', 'Link berita disalin ke clipboard',
        snackPosition: SnackPosition.BOTTOM);
  }
}
