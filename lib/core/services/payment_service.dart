import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  late Razorpay _razorpay;
  late String _orderId;
  late String _requestId;

  void init({
    required String orderId,
    required String requestId,
    required Function(String, String) onSuccess,
    required Function(String) onError,
  }) {
    _orderId = orderId;
    _requestId = requestId;

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      (res) => onSuccess(res.paymentId!, res.signature!),
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      (res) => onError(res.message ?? "Payment failed"),
    );
  }

  void openCheckout(int amount) {
    _razorpay.open({
      'key': 'rzp_test_xxxxxxxxx',
      'amount': amount * 100,
      'currency': 'BHD',
      'order_id': _orderId,
      'name': 'Local Skill Share',
    });
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String signature,
  }) async {
    await http.post(
      Uri.parse("https://YOUR-NGROK-URL/verify-payment"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "orderId": _orderId,
        "paymentId": paymentId,
        "signature": signature,
        "requestId": _requestId,
      }),
    );
  }

  void dispose() {
    _razorpay.clear();
  }
}
