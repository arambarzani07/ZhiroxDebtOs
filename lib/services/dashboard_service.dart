import '../core/network/api_client.dart';
import '../models/dashboard_summary_model.dart';

class DashboardServiceApi {
  DashboardServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<DashboardSummaryModel> summary() async {
    final data = await client.get(baseUrl, '/summary');
    return DashboardSummaryModel.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
