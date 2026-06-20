import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';

class QualityServiceApi {
  QualityServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<Map<String, dynamic>> runCheck() async {
    final data = await client.get(baseUrl, '/scan');
    return ResponseReader.mapFrom(data);
  }
}
