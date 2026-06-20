import '../core/network/api_client.dart';
import '../models/customer_model.dart';

class CustomerServiceApi {
  CustomerServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<List<CustomerModel>> listCustomers() async {
    final data = await client.get(baseUrl, '/list');
    final raw = data is List ? data : (data['customers'] ?? data['data'] ?? []);
    return List<CustomerModel>.from(
      raw.map((item) => CustomerModel.fromJson(Map<String, dynamic>.from(item))),
    );
  }

  Future<Map<String, dynamic>> rawProfile(int customerId) async {
    final data = await client.get(baseUrl, '/id', query: {'id': customerId});
    return Map<String, dynamic>.from(data as Map);
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> body) async {
    final data = await client.post(baseUrl, '/create', body: body);
    return Map<String, dynamic>.from(data as Map);
  }
}
