import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';
import '../models/dashboard_summary_model.dart';

class DashboardServiceApi {
  DashboardServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<DashboardSummaryModel> summary() async {
    final data = await client.get(baseUrl, '/summary');
    final map = ResponseReader.mapFrom(data);
    final payload = ResponseReader.mapFrom(
      ResponseReader.pick(map, ['summary', 'dashboard', 'data']) ?? map,
    );
    return DashboardSummaryModel.fromJson(payload);
  }
}
