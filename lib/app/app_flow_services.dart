import '../core/config/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../services/approval_flow_service.dart';
import '../services/money_flow_service.dart';

class AppFlowServices {
  AppFlowServices({
    required this.money,
    required this.approvals,
  });

  factory AppFlowServices.fromClient(ApiClient client) {
    return AppFlowServices(
      money: MoneyFlowService(
        client: client,
        baseUrl: ApiEndpoints.finance,
      ),
      approvals: ApprovalFlowService(
        client: client,
        baseUrl: ApiEndpoints.approvals,
      ),
    );
  }

  final MoneyFlowService money;
  final ApprovalFlowService approvals;
}
