import 'package:flutter/material.dart';

import '../../app/app_flow_services.dart';
import '../../app/app_services.dart';
import '../../models/customer_model.dart';
import 'customer_profile_actions.dart';
import 'profile_loader.dart';

void openCustomerProfile({
  required BuildContext context,
  required CustomerModel customer,
  required AppServices services,
}) {
  final flows = AppFlowServices.fromClient(services.apiClient);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => ProfileLoader(
        customer: customer,
        service: services.customers,
        lockedBackend: services.lockedBackend,
        actions: CustomerProfileActions(
          money: flows.money,
          approvals: flows.approvals,
        ),
      ),
    ),
  );
}
