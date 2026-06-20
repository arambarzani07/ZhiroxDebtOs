class FinancialEventResultModel {
  const FinancialEventResultModel({
    required this.status,
    required this.currentBalance,
    this.approvalRequestId,
    this.financialEventId,
    this.receiptId,
    this.message = '',
  });

  final String status;
  final num currentBalance;
  final int? approvalRequestId;
  final int? financialEventId;
  final int? receiptId;
  final String message;

  bool get needsApproval => status == 'pending_approval' && approvalRequestId != null;

  factory FinancialEventResultModel.fromJson(Map<String, dynamic> json) {
    int? readInt(String key) {
      final value = int.tryParse('${json[key] ?? ''}');
      return value == 0 ? null : value;
    }

    num readBalance() {
      if (json['current_balance'] != null) {
        return num.tryParse('${json['current_balance']}') ?? 0;
      }
      final profile = json['customer_profile'];
      if (profile is Map && profile['current_balance'] != null) {
        return num.tryParse('${profile['current_balance']}') ?? 0;
      }
      return 0;
    }

    int? receiptId;
    final receipt = json['receipt'];
    if (receipt is Map) {
      receiptId = int.tryParse('${receipt['id'] ?? ''}');
    }

    return FinancialEventResultModel(
      status: '${json['status'] ?? json['financial_event']?['status'] ?? 'posted'}',
      currentBalance: readBalance(),
      approvalRequestId: readInt('approval_request_id'),
      financialEventId: readInt('financial_event_id'),
      receiptId: receiptId,
      message: '${json['message'] ?? ''}',
    );
  }
}
