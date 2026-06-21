import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../models/financial_event_model.dart';
import '../../models/ledger_entry_model.dart';
import '../../widgets/customer_balance_card.dart';
import '../../widgets/customer_ledger_timeline.dart';
import '../../widgets/financial_action_bar.dart';
import '../../widgets/financial_result_panel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.customer,
    required this.profile,
    required this.onDebt,
    required this.onPayment,
    this.ledger = const [],
    this.lastResult,
    this.onApprove,
    this.onReject,
    this.loading = false,
  });

  final CustomerModel customer;
  final CustomerProfileModel profile;
  final VoidCallback onDebt;
  final VoidCallback onPayment;
  final List<LedgerEntryModel> ledger;
  final FinancialEventResultModel? lastResult;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        CustomerBalanceCard(
          customerName: customer.fullName,
          phone: customer.phone,
          currentBalance: '${profile.currentBalance} IQD',
          creditLimit: '${profile.creditLimit} IQD',
          trustScore: '${profile.trustScore}',
          riskLevel: profile.riskLevel,
          debtHealth: profile.debtHealth,
        ),
        const SizedBox(height: 12),
        if (lastResult != null) ...[
          FinancialResultPanel(
            result: lastResult!,
            onApprove: onApprove,
            onReject: onReject,
            loading: loading,
          ),
          const SizedBox(height: 12),
        ],
        FinancialActionBar(
          onDebt: onDebt,
          onPayment: onPayment,
          loading: loading,
        ),
        const SizedBox(height: 12),
        CustomerLedgerTimeline(entries: ledger),
      ],
    );
  }
}
