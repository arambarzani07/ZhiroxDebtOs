import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';
import '../models/customer_model.dart';

class CustomerServiceApi {
  CustomerServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<List<CustomerModel>> listCustomers() async {
    final data = await client.get(baseUrl, '/list');
    final map = ResponseReader.mapFrom(data);
    final raw = data is List
        ? data
        : ResponseReader.pick(map, [
              'customers',
              'items',
              'data',
              'records',
              'rows',
              'list',
            ]) ??
            const [];
    return ResponseReader.listFrom(raw).map(CustomerModel.fromJson).toList();
  }

  Future<Map<String, dynamic>> rawProfile(int customerId) async {
    final data = await client.get(baseUrl, '/id', query: {'id': customerId});
    return ResponseReader.mapFrom(data);
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> body) async {
    final data = await client.post(baseUrl, '/create', body: body);
    return ResponseReader.mapFrom(data);
  }
}
