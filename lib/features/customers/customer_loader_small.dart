import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../services/customer_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_page.dart';
import 'customer_create_dialog.dart';
import 'customer_list_screen.dart';

class CustomerLoaderSmall extends StatefulWidget {
  const CustomerLoaderSmall({
    super.key,
    required this.service,
    required this.onOpen,
  });

  final CustomerServiceApi service;
  final ValueChanged<CustomerModel> onOpen;

  @override
  State<CustomerLoaderSmall> createState() => _CustomerLoaderSmallState();
}

class _CustomerLoaderSmallState extends State<CustomerLoaderSmall> {
  late Future<List<CustomerModel>> customers;
  bool creating = false;

  @override
  void initState() {
    super.initState();
    customers = widget.service.listCustomers();
  }

  void reload() {
    setState(() => customers = widget.service.listCustomers());
  }

  Future<void> createCustomer() async {
    final input = await showDialog<CustomerCreateInput>(
      context: context,
      builder: (dialogContext) => const CustomerCreateDialog(),
    );
    if (input == null) return;
    setState(() => creating = true);
    try {
      await widget.service.createCustomer(input.toJson());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('کڕیار زیادکرا')),
      );
      reload();
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CustomerModel>>(
      future: customers,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingPage());
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: ErrorView(message: snapshot.error.toString(), onRetry: reload),
          );
        }
        return CustomerListScreen(
          customers: snapshot.data ?? const <CustomerModel>[],
          onRefresh: reload,
          onCreate: creating ? null : createCustomer,
          onOpenCustomer: widget.onOpen,
        );
      },
    );
  }
}
