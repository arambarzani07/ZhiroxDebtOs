import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../models/financial_event_model.dart';
import '../../widgets/customer_balance_card.dart';
import '../../widgets/financial_action_bar.dart';
import '../../widgets/financial_result_panel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.customer,
    required this.profile,
    required this.onDebt,
    required this.onPayment,
    this.lastResult,
    this.loading = false,
  });

  final CustomerModel customer;
  final CustomerProfileModel profile;
  final VoidCallback onDebt;
  final VoidCallback onPayment;
  final FinancialEventResultModel? lastResult;
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
          FinancialResultPanel(result: lastResult!),
          const SizedBox(height: 12),
        ],
        FinancialActionBar(
          onDebt: onDebt,
          onPayment: onPayment,
          loading: loading,
        ),
      ],
    );
  }
}
