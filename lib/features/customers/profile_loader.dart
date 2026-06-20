import 'package:flutter/material.dart';

import '../../core/utils/response_reader.dart';
import '../../models/customer_model.dart';
import '../../services/customer_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_page.dart';
import 'profile_screen.dart';

class ProfileLoader extends StatefulWidget {
  const ProfileLoader({
    super.key,
    required this.customer,
    required this.service,
  });

  final CustomerModel customer;
  final CustomerServiceApi service;

  @override
  State<ProfileLoader> createState() => _ProfileLoaderState();
}

class _ProfileLoaderState extends State<ProfileLoader> {
  late Future<CustomerProfileModel> future;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    future = loadProfile();
  }

  Future<CustomerProfileModel> loadProfile() async {
    final data = await widget.service.rawProfile(widget.customer.id);
    final map = ResponseReader.mapFrom(
      ResponseReader.pick(data, ['profile', 'customer_profile', 'data']) ?? data,
    );
    return CustomerProfileModel.fromJson(map);
  }

  void reload() {
    setState(() => future = loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CustomerProfileModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingPage());
        }
        if (snapshot.hasError) {
          return Scaffold(body: ErrorView(message: snapshot.error.toString(), onRetry: reload));
        }
        final profile = snapshot.data;
        if (profile == null) {
          return Scaffold(body: ErrorView(message: 'No profile data', onRetry: reload));
        }
        return Scaffold(
          appBar: AppBar(title: Text(widget.customer.fullName)),
          body: ProfileScreen(
            customer: widget.customer,
            profile: profile,
            onDebt: () {},
            onPayment: () {},
            loading: loading,
          ),
        );
      },
    );
  }
}
