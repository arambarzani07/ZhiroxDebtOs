import '../../models/financial_event_model.dart';
import '../../services/approval_flow_service.dart';
import '../../services/money_flow_service.dart';

class CustomerProfileActions {
  CustomerProfileActions({
    required this.money,
    required this.approvals,
  });

  final MoneyFlowService money;
  final ApprovalFlowService approvals;

  Future<FinancialEventResultModel> giveDebt({
    required int customerId,
    required num amount,
    String note = '',
  }) {
    return money.giveDebt(
      customerId: customerId,
      amount: amount,
      note: note,
    );
  }

  Future<FinancialEventResultModel> receivePayment({
    required int customerId,
    required num amount,
    String note = '',
  }) {
    return money.receivePayment(
      customerId: customerId,
      amount: amount,
      note: note,
    );
  }

  Future<Map<String, dynamic>> approve(int requestId) {
    return approvals.approve(requestId);
  }

  Future<Map<String, dynamic>> reject(int requestId) {
    return approvals.reject(requestId);
  }
}
