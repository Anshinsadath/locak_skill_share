import 'package:flutter/material.dart';
import 'stripe_service.dart';

class PaymentTestScreen extends StatelessWidget {
  const PaymentTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Payment Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            StripeService.makePayment(500); // $5.00
          },
          child: const Text("Pay \$5"),
        ),
      ),
    );
  }
}
