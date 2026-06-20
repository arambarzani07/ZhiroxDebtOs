class ApiConfig {
  static const String authBaseUrl = 'https://x8ki-letl-twmt.n7.xano.io/api:zhirox-auth';

  static String group(String slug) => authBaseUrl.replaceFirst('zhirox-auth', slug);

  static String get customers => group('zhirox-customers');
  static String get financialEvents => group('zhirox-financial-events');
  static String get approvals => group('zhirox-approvals');
  static String get dashboard => group('zhirox-dashboard');
  static String get reports => group('zhirox-reports');
  static String get receipts => group('zhirox-receipts');
  static String get dataQuality => group('zhirox-data-quality');
}
