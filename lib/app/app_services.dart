import '../core/config/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/storage/token_storage.dart';
import '../services/customer_service.dart';
import '../services/dashboard_service.dart';
import '../services/quality_service.dart';
import '../services/report_daily_service.dart';

class AppServices {
  AppServices._({
    required this.storage,
    required this.apiClient,
    required this.customers,
    required this.dashboard,
    required this.quality,
    required this.reports,
  });

  factory AppServices() {
    final storage = TokenStorage();
    final client = ApiClient(storage);

    return AppServices._(
      storage: storage,
      apiClient: client,
      customers: CustomerServiceApi(
        client: client,
        baseUrl: ApiEndpoints.customers,
      ),
      dashboard: DashboardServiceApi(
        client: client,
        baseUrl: ApiEndpoints.dashboard,
      ),
      quality: QualityServiceApi(
        client: client,
        baseUrl: ApiEndpoints.quality,
      ),
      reports: ReportDailyService(
        client: client,
        baseUrl: ApiEndpoints.reports,
      ),
    );
  }

  final TokenStorage storage;
  final ApiClient apiClient;
  final CustomerServiceApi customers;
  final DashboardServiceApi dashboard;
  final QualityServiceApi quality;
  final ReportDailyService reports;
}
