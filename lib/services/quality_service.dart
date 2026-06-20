import '../core/network/api_client.dart';

class QualityServiceApi {
  QualityServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<Map<String, dynamic>> runCheck() async {
    final data = await client.get(baseUrl, '/scan');
    return Map<String, dynamic>.from(data as Map);
  }
}
