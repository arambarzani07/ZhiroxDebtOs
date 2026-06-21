import 'package:flutter/material.dart';

import '../../core/utils/response_reader.dart';
import '../../models/customer_model.dart';
import '../../models/financial_event_model.dart';
import '../../models/ledger_entry_model.dart';
import '../../services/customer_service.dart';
import '../../services/locked_backend_service.dart';
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
    this.lockedBackend,
  });

  final CustomerModel customer;
  final CustomerServiceApi service;
  final CustomerProfileActions? actions;
  final LockedBackendService? lockedBackend;

  @override
  State<ProfileLoader> createState() => _ProfileLoaderState();
}

class _ProfileLoadResult {
  const _ProfileLoadResult({required this.profile, required this.ledger});

  final CustomerProfileModel profile;
  final List<LedgerEntryModel> ledger;
}

class _ProfileLoaderState extends State<ProfileLoader> {
  late Future<_ProfileLoadResult> future;
  bool loading = false;
  FinancialEventResultModel? lastResult;

  @override
  void initState() {
    super.initState();
    future = loadProfile();
  }

  Future<_ProfileLoadResult> loadProfile() async {
    final data = await widget.service.rawProfile(widget.customer.id);
    final map = ResponseReader.mapFrom(
      ResponseReader.pick(data, ['profile', 'customer_profile', 'data']) ?? data,
    );
    final profile = CustomerProfileModel.fromJson(map);
    final ledger = await loadLedgerSafely();
    return _ProfileLoadResult(profile: profile, ledger: ledger);
  }

  Future<List<LedgerEntryModel>> loadLedgerSafely() async {
    final lockedBackend = widget.lockedBackend;
    if (lockedBackend == null) return const [];
    try {
      final statement = await lockedBackend.customerStatement(widget.customer.id);
      final map = ResponseReader.mapFrom(statement);
      final rawLedger = ResponseReader.pick(map, ['ledger', 'items']) ?? const [];
      return LedgerEntryModel.listFrom(rawLedger);
    } catch (_) {
      return const [];
    }
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
      setState(() => lastResult = result);
      final text = result.needsApproval ? 'پێویستی بە ڕەزامەندی هەیە' : 'کارەکە تۆمار کرا';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
      reload();
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> runApproval({required bool approve}) async {
    final actions = widget.actions;
    final requestId = lastResult?.approvalRequestId;
    if (actions == null || requestId == null) return;

    setState(() => loading = true);
    try {
      if (approve) {
        await actions.approve(requestId);
      } else {
        await actions.reject(requestId);
      }
      if (!mounted) return;
      setState(() => lastResult = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(approve ? 'ڕەزامەندی درا' : 'داواکاری ڕەتکرایەوە')),
      );
      reload();
    } catch (error) {
      if (mounted) showErrorSnack(context, error.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ProfileLoadResult>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingPage());
        }
        if (snapshot.hasError) {
          return Scaffold(body: ErrorView(message: snapshot.error.toString(), onRetry: reload));
        }
        final result = snapshot.data;
        if (result == null) {
          return Scaffold(body: ErrorView(message: 'No profile data', onRetry: reload));
        }
        return Scaffold(
          appBar: AppBar(title: Text(widget.customer.fullName)),
          body: ProfileScreen(
            customer: widget.customer,
            profile: result.profile,
            ledger: result.ledger,
            onDebt: () => runMoneyAction(debt: true),
            onPayment: () => runMoneyAction(debt: false),
            lastResult: lastResult,
            onApprove: () => runApproval(approve: true),
            onReject: () => runApproval(approve: false),
            loading: loading,
          ),
        );
      },
    );
  }
}
