import 'package:dio/dio.dart';
import '../config/env.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => // baru di dio 5.10.0
        ApiException('Koneksi lambat. Server tidak merespons tepat waktu.'),
      DioExceptionType.connectionError =>
        ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.'),
      DioExceptionType.badCertificate =>
        ApiException('Sertifikat keamanan server tidak valid.'),
      DioExceptionType.cancel => ApiException('Permintaan dibatalkan.'),
      DioExceptionType.badResponse => _dariResponse(e.response),
      DioExceptionType.unknown => ApiException(
          'Terjadi kesalahan tak terduga: ${Env.samarkan(e.message ?? '-')}',
        ),
    };
  }

  /// GNews mengirim {"errors": ["pesan"]} atau {"errors": {"q": "pesan"}}
  static ApiException _dariResponse(Response<dynamic>? response) {
    final code = response?.statusCode;
    final pesanServer = _ambilPesanServer(response?.data);

    final pesan = switch (code) {
      400 => 'Permintaan tidak valid. ${pesanServer ?? ''}',
      401 => 'API key salah atau tidak terdaftar.',
      403 => 'Kuota harian habis atau email akun belum diverifikasi.',
      404 => 'Alamat endpoint tidak ditemukan.',
      429 => 'Terlalu cepat. Paket gratis hanya 1 request per detik.',
      final c? when c >= 500 => 'Server GNews sedang bermasalah ($c).',
      _ => 'Gagal memuat data (kode ${code ?? '-'}).',
    };
    return ApiException(pesan.trim(), statusCode: code);
  }

  static String? _ambilPesanServer(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    if (errors is Map && errors.isNotEmpty) return errors.values.first.toString();
    return null;
  }

  @override
  String toString() => message;
}
