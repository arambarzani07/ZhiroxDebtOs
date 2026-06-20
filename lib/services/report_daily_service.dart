import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';
import '../models/daily_report_model.dart';

class ReportDailyService {
  ReportDailyService({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<DailyReportModel> today() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final data = await client.get(baseUrl, '/daily', query: {
      'branch_id': 0,
      'date': today,
    });
    return DailyReportModel.fromJson(ResponseReader.mapFrom(data));
  }
}
