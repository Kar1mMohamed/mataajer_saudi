import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payments_redirect_controller.dart';

class PaymentsRedirectView extends GetView<PaymentsRedirectController> {
  const PaymentsRedirectView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaymentsRedirectView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PaymentsRedirectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
