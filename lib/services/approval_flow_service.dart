import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';

class ApprovalFlowService {
  ApprovalFlowService({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<Map<String, dynamic>> approve(int requestId) async {
    final data = await client.post(baseUrl, '/approve', body: {
      'approval_request_id': requestId,
    });
    return ResponseReader.mapFrom(data);
  }

  Future<Map<String, dynamic>> reject(int requestId) async {
    final data = await client.post(baseUrl, '/reject', body: {
      'approval_request_id': requestId,
    });
    return ResponseReader.mapFrom(data);
  }
}
