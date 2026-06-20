import '../core/network/api_client.dart';
import '../core/utils/response_reader.dart';
import '../models/financial_event_model.dart';

class MoneyFlowService {
  MoneyFlowService({required this.client, required this.baseUrl});

  final ApiClient client;
  final String baseUrl;

  Future<FinancialEventResultModel> giveDebt({
    required int customerId,
    required num amount,
    String note = '',
  }) async {
    final data = await client.post(baseUrl, '/give-debt', body: {
      'customer_id': customerId,
      'amount': amount,
      'note': note,
    });
    return FinancialEventResultModel.fromJson(ResponseReader.mapFrom(data));
  }

  Future<FinancialEventResultModel> receivePayment({
    required int customerId,
    required num amount,
    String note = '',
  }) async {
    final data = await client.post(baseUrl, '/receive-payment', body: {
      'customer_id': customerId,
      'amount': amount,
      'note': note,
    });
    return FinancialEventResultModel.fromJson(ResponseReader.mapFrom(data));
  }
}
