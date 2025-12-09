import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeService {
  static final Dio _dio = Dio();

  static Future<void> makePayment(int amount) async {
    try {
      // 1️⃣ Ask backend to create PaymentIntent
      final response = await _dio.post(
        '${dotenv.env['BACKEND_URL']}/create-payment-intent',
        data: {'amount': amount},
      );

      final clientSecret = response.data['clientSecret'];

      // 2️⃣ Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Local Skill Share',
        ),
      );

      // 3️⃣ Show Stripe payment UI
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print("❌ Payment failed: $e");
      rethrow;
    }
  }
}
