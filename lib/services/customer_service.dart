import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';
import '../models/customer_model.dart';

class CustomerServiceApi {
  CustomerServiceApi({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<List<CustomerModel>> listCustomers() async {
    final data = await client.get(
      baseUrl,
      '/list',
      query: const {
        'market_id': 0,
        'branch_id': 0,
        'status': 'active',
      },
    );
    final raw = _readCustomerList(data);
    return ResponseReader.listFrom(raw).map(CustomerModel.fromJson).where((customer) => customer.id != 0).toList();
  }

  dynamic _readCustomerList(dynamic data) {
    if (data is List) return data;
    final map = ResponseReader.mapFrom(data);
    final direct = ResponseReader.pick(map, [
      'customers',
      'items',
      'data',
      'records',
      'rows',
      'list',
      'result',
    ]);
    if (direct is List) return direct;
    final result = ResponseReader.mapFrom(direct);
    final nested = ResponseReader.pick(result, [
      'customers',
      'items',
      'data',
      'records',
      'rows',
      'list',
    ]);
    if (nested is List) return nested;
    final payload = ResponseReader.mapFrom(map['payload']);
    final payloadItems = ResponseReader.pick(payload, [
      'customers',
      'items',
      'data',
      'records',
      'rows',
      'list',
    ]);
    if (payloadItems is List) return payloadItems;
    return const [];
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
