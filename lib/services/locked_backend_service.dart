import '../core/config/api_endpoints.dart';
import '../core/network/api_client.dart';

class LockedBackendService {
  LockedBackendService({required this.client});

  final ApiClient client;

  Map<String, dynamic> _clean(Map<String, dynamic> values) {
    final result = <String, dynamic>{};
    values.forEach((key, value) {
      if (value != null) result[key] = value;
    });
    return result;
  }

  Future<dynamic> customerStatement(int customerId) {
    return client.get(
      ApiEndpoints.customers,
      '/customer-statement',
      query: {'customer_id': customerId},
    );
  }

  Future<dynamic> customerLedger(
    int customerId, {
    String? status,
    int? limit,
    int? offset,
  }) {
    return client.get(
      ApiEndpoints.finance,
      '/customer-ledger',
      query: _clean({
        'customer_id': customerId,
        'status': status,
        'limit': limit,
        'offset': offset,
      }),
    );
  }

  Future<dynamic> receiptVerify(String verifyToken) {
    return client.get(
      ApiEndpoints.receipts,
      '/verify',
      query: {'verify_token': verifyToken},
    );
  }

  Future<dynamic> receiptsByCustomer(
    int customerId, {
    String? status,
    int? limit,
    int? offset,
  }) {
    return client.get(
      ApiEndpoints.receipts,
      '/by-customer',
      query: _clean({
        'customer_id': customerId,
        'status': status,
        'limit': limit,
        'offset': offset,
      }),
    );
  }

  Future<dynamic> reportDaily({
    String? date,
    int? marketId,
    int? branchId,
  }) {
    return client.get(
      ApiEndpoints.reports,
      '/daily',
      query: _clean({
        'date': date,
        'market_id': marketId,
        'branch_id': branchId,
      }),
    );
  }

  Future<dynamic> reportWeekly({
    String? startDate,
    String? endDate,
    int? marketId,
    int? branchId,
  }) {
    return client.get(
      ApiEndpoints.reports,
      '/weekly',
      query: _clean({
        'start_date': startDate,
        'end_date': endDate,
        'market_id': marketId,
        'branch_id': branchId,
      }),
    );
  }

  Future<dynamic> reportMonthly({
    int? month,
    int? year,
    int? marketId,
    int? branchId,
  }) {
    return client.get(
      ApiEndpoints.reports,
      '/monthly',
      query: _clean({
        'month': month,
        'year': year,
        'market_id': marketId,
        'branch_id': branchId,
      }),
    );
  }

  Future<dynamic> reportTopDebtors({int? limit, int? marketId, int? branchId}) {
    return client.get(
      ApiEndpoints.reports,
      '/top-debtors',
      query: _clean({
        'limit': limit,
        'market_id': marketId,
        'branch_id': branchId,
      }),
    );
  }

  Future<dynamic> reportPaidUnpaid({int? marketId, int? branchId}) {
    return client.get(
      ApiEndpoints.reports,
      '/paid-unpaid',
      query: _clean({'market_id': marketId, 'branch_id': branchId}),
    );
  }

  Future<dynamic> reportApproval({String? startDate, String? endDate}) {
    return client.get(
      ApiEndpoints.reports,
      '/approval-report',
      query: _clean({'start_date': startDate, 'end_date': endDate}),
    );
  }

  Future<dynamic> reportCashMovement({String? startDate, String? endDate}) {
    return client.get(
      ApiEndpoints.reports,
      '/cash-movement',
      query: _clean({'start_date': startDate, 'end_date': endDate}),
    );
  }

  Future<dynamic> reportEmployeeActivity({String? startDate, String? endDate}) {
    return client.get(
      ApiEndpoints.reports,
      '/employee-activity',
      query: _clean({'start_date': startDate, 'end_date': endDate}),
    );
  }

  Future<dynamic> reportBranchSummary({int? marketId, int? branchId}) {
    return client.get(
      ApiEndpoints.reports,
      '/branch-summary',
      query: _clean({'market_id': marketId, 'branch_id': branchId}),
    );
  }

  Future<dynamic> dataQualityScan({int? marketId, int? branchId}) {
    return client.get(
      ApiEndpoints.quality,
      '/scan',
      query: _clean({'market_id': marketId, 'branch_id': branchId}),
    );
  }

  Future<dynamic> fixCustomerBalance(int customerId, {String? note}) {
    return client.post(
      ApiEndpoints.quality,
      '/fix-balance',
      body: _clean({'customer_id': customerId, 'note': note}),
    );
  }

  Future<dynamic> fixMissingProfile({int? customerId}) {
    return client.post(
      ApiEndpoints.quality,
      '/fix-missing-profile',
      body: _clean({'customer_id': customerId}),
    );
  }

  Future<dynamic> fixReceiptLink({int? ledgerEntryId, int? customerId}) {
    return client.post(
      ApiEndpoints.quality,
      '/fix-receipt-link',
      body: _clean({'ledger_entry_id': ledgerEntryId, 'customer_id': customerId}),
    );
  }

  Future<dynamic> paymentReminderDraft(int customerId, {String? note}) {
    return client.post(
      ApiEndpoints.whatsapp,
      '/payment-reminder-draft',
      body: _clean({'customer_id': customerId, 'note': note}),
    );
  }

  Future<dynamic> receiptMessageDraft(int receiptId) {
    return client.post(
      ApiEndpoints.whatsapp,
      '/receipt-message-draft',
      body: {'receipt_id': receiptId},
    );
  }

  Future<dynamic> customerStatementDraft(int customerId) {
    return client.post(
      ApiEndpoints.whatsapp,
      '/customer-statement-draft',
      body: {'customer_id': customerId},
    );
  }

  Future<dynamic> marketSettings({int? marketId, int? branchId}) {
    return client.get(
      ApiEndpoints.settings,
      '/market-settings',
      query: _clean({'market_id': marketId, 'branch_id': branchId}),
    );
  }

  Future<dynamic> permissions({int? userId, String? role}) {
    return client.get(
      ApiEndpoints.settings,
      '/permissions',
      query: _clean({'user_id': userId, 'role': role}),
    );
  }

  Future<dynamic> licenseStatus(int marketId) {
    return client.get(
      ApiEndpoints.settings,
      '/license-status',
      query: {'market_id': marketId},
    );
  }

  Future<dynamic> exportCustomers({int? marketId, int? branchId}) {
    return client.post(
      ApiEndpoints.exports,
      '/customers',
      body: _clean({'market_id': marketId, 'branch_id': branchId}),
    );
  }

  Future<dynamic> exportLedger({int? customerId, String? startDate, String? endDate}) {
    return client.post(
      ApiEndpoints.exports,
      '/ledger',
      body: _clean({
        'customer_id': customerId,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );
  }
}
