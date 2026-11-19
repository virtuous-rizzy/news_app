import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_controller.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/news_image.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final a = controller.article;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (a.urlToImage != null) NewsImage(url: a.urlToImage!, height: 240),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '${a.author ?? '-'}  •  ${DateFormatter.formatDate(a.publishedAt)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  if (a.description != null)
                    Text(a.description!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  if (a.content != null)
                    Text(a.content!, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 24),
                  if (a.url != null) ...[
                    SelectableText(a.url!,
                        style: const TextStyle(color: AppColors.secondary)),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: controller.salinLink,
                      icon: const Icon(Icons.copy),
                      label: const Text('Salin Link'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
