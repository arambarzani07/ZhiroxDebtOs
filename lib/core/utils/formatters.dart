class AppFormatters {
  const AppFormatters._();

  static String money(dynamic value, {String currency = 'IQD'}) {
    final number = num.tryParse('$value') ?? 0;
    final text = number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '$text $currency';
  }

  static String safeText(dynamic value, {String fallback = '—'}) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty ? fallback : text;
  }

  static int safeInt(dynamic value) {
    return int.tryParse('${value ?? 0}') ?? 0;
  }

  static num safeNum(dynamic value) {
    return num.tryParse('${value ?? 0}') ?? 0;
  }
}
