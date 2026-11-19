class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment('GNEWS_BASE_URL');
  static const String apiKey = String.fromEnvironment('GNEWS_API_KEY');

  /// Key boleh kosong (mode production lewat proxy).
  static bool get lengkap => baseUrl.isNotEmpty;

  /// true hanya saat development (key dikirim langsung dari aplikasi).
  static bool get pakaiKeyLangsung => apiKey.isNotEmpty;

  /// Menyamarkan API key di teks log / pesan error.
  static String samarkan(String teks) {
    var hasil = teks.replaceAllMapped(
      RegExp(r'(apikey=)[^&\s"]+', caseSensitive: false),
      (m) => '${m[1]}***',
    );
    if (apiKey.isNotEmpty) hasil = hasil.replaceAll(apiKey, '***');
    return hasil;
  }
}
