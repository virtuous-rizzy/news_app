import 'package:flutter/material.dart';

/// Palet: 00105B, 6061B6, C9B5E0, FCF9EC
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00105B); // navy: AppBar, teks utama
  static const Color secondary = Color(0xFF6061B6); // indigo: chip aktif, tombol, link
  static const Color accent = Color(0xFFC9B5E0); // lavender: chip tidak aktif, aksen
  static const Color background = Color(0xFFFCF9EC); // krem: latar halaman
  static const Color surface = Color(0xFFFFFFFF); // kartu
  static const Color textPrimary = primary;
  static const Color textSecondary = Color(0xB300105B); // navy 70% (turunan)
  static const Color error = Color(0xFFD32F2F);
}
