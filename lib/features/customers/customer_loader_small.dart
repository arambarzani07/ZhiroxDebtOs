import 'package:flutter/material.dart';

import '../../models/customer_model.dart';
import '../../services/customer_service.dart';
import '../../widgets/loading_page.dart';
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

  @override
  void initState() {
    super.initState();
    customers = widget.service.listCustomers();
  }

  void reload() {
    setState(() => customers = widget.service.listCustomers());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CustomerModel>>(
      future: customers,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingPage());
        }
        return CustomerListScreen(
          customers: snapshot.data ?? const <CustomerModel>[],
          onRefresh: reload,
          onCreate: () {},
          onOpenCustomer: widget.onOpen,
        );
      },
    );
  }
}
