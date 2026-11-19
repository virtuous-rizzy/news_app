import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Contoh: 18 November 2026, 07.30
  /// Butuh initializeDateFormatting('id_ID') di main().
  static String formatDate(String iso) {
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return '-';
    return DateFormat('d MMMM yyyy, HH.mm', 'id_ID').format(parsed.toLocal());
  }
}
