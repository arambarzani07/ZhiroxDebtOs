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

  static String statusLabel(dynamic value) {
    switch (safeText(value, fallback: '').toLowerCase()) {
      case 'posted':
        return 'تۆمارکراو';
      case 'pending':
      case 'pending_approval':
        return 'چاوەڕوانی ڕەزامەندی';
      case 'approved':
        return 'ڕەزامەندی دراو';
      case 'rejected':
        return 'ڕەتکراوە';
      case 'voided':
        return 'هەڵوەشاوە';
      case 'cancelled':
      case 'canceled':
        return 'پاشگەزکراوە';
      case 'ready':
        return 'ئامادە';
      case 'draft':
        return 'Draft';
      case 'active':
        return 'چالاک';
      case 'blocked':
        return 'بەربەستکراو';
      case 'trial':
        return 'تاقیکردنەوە';
      default:
        return safeText(value);
    }
  }

  static String riskLabel(dynamic value) {
    switch (safeText(value, fallback: '').toLowerCase()) {
      case 'low':
        return 'نزم';
      case 'medium':
        return 'مامناوەند';
      case 'high':
        return 'بەرز';
      case 'critical':
        return 'مەترسیدار';
      default:
        return safeText(value);
    }
  }

  static String debtHealthLabel(dynamic value) {
    switch (safeText(value, fallback: '').toLowerCase()) {
      case 'healthy':
      case 'good':
        return 'باش';
      case 'watch':
        return 'چاودێری';
      case 'danger':
        return 'مەترسی';
      case 'blocked':
        return 'قفڵکراو';
      default:
        return safeText(value);
    }
  }
}
