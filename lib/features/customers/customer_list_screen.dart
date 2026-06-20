import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../widgets/customer_summary_card.dart';
import '../../widgets/empty_state.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({
    super.key,
    required this.customers,
    required this.onRefresh,
    required this.onCreate,
    required this.onOpenCustomer,
  });

  final List<CustomerModel> customers;
  final VoidCallback onRefresh;
  final VoidCallback onCreate;
  final ValueChanged<CustomerModel> onOpenCustomer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کڕیارەکان'),
        actions: [
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onCreate,
        icon: const Icon(Icons.person_add),
        label: const Text('کڕیاری نوێ'),
      ),
      body: customers.isEmpty
          ? const EmptyState(title: 'هێشتا هیچ کڕیارێک نییە')
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return CustomerSummaryCard(
                  name: customer.fullName,
                  phone: customer.phone,
                  balance: '—',
                  onTap: () => onOpenCustomer(customer),
                );
              },
            ),
    );
  }
}
