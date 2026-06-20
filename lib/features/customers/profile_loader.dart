import 'package:flutter/material.dart';

import '../../core/utils/response_reader.dart';
import '../../models/customer_model.dart';
import '../../models/financial_event_model.dart';
import '../../services/customer_service.dart';
import '../../widgets/amount_input_dialog.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_page.dart';
import 'customer_profile_actions.dart';
import 'profile_screen.dart';

class ProfileLoader extends StatefulWidget {
  const ProfileLoader({
    super.key,
    required this.customer,
    required this.service,
    this.actions,
  });

  final CustomerModel customer;
  final CustomerServiceApi service;
  final CustomerProfileActions? actions;

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

  Future<void> runMoneyAction({required bool debt}) async {
    final actions = widget.actions;
    if (actions == null) return;
    final input = await showAmountInputDialog(
      context: context,
      title: debt ? 'قەرزدان' : 'پارە وەرگرتن',
    );
    if (input == null) return;

    setState(() => loading = true);
    try {
      final FinancialEventResultModel result = debt
          ? await actions.giveDebt(customerId: widget.customer.id, amount: input.amount, note: input.note)
          : await actions.receivePayment(customerId: widget.customer.id, amount: input.amount, note: input.note);
      if (!mounted) return;
      final text = result.needsApproval ? 'پێویستی بە ڕەزامەندی هەیە' : 'کارەکە تۆمار کرا';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
      reload();
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
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
            onDebt: () => runMoneyAction(debt: true),
            onPayment: () => runMoneyAction(debt: false),
            loading: loading,
          ),
        );
      },
    );
  }
}
