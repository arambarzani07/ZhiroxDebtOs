class ApiEndpoints {
  const ApiEndpoints._();

  static const base = 'https://x8ki-letl-twmt.n7.xano.io/api:zhirox-auth';

  static String group(String slug) => base.replaceFirst('zhirox-auth', slug);

  static String get auth => base;
  static String get customers => group('zhirox-customers');
  static String get dashboard => group('zhirox-dashboard');
  static String get reports => group('zhirox-reports');
  static String get quality => group('zhirox-data-quality');
  static String get approvals => group('zhirox-approvals');
  static String get finance => group('zhirox-financial-events');
  static String get receipts => group('zhirox-receipts');
  static String get settings => group('zhirox-settings');
  static String get whatsapp => group('zhirox-whatsapp');
  static String get exports => group('zhirox-exports');
}
