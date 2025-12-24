import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;
  late String _orderId;
  late String _requestId;
  late Function(String, String) _onSuccess;
  late Function(String) _onError;

  void init({
    required String orderId,
    required String requestId,
    required Function(String paymentId, String signature) onSuccess,
    required Function(String error) onError,
  }) {
    _orderId = orderId;
    _requestId = requestId;
    _onSuccess = onSuccess;
    _onError = onError;

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      (res) => _onSuccess(res.paymentId!, res.signature!),
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      (res) => _onError(res.message ?? 'Payment failed'),
    );
  }

  void openCheckout({
    required int amount,
    required String razorpayKey,
  }) {
    _razorpay.open({
      'key': razorpayKey,
      'amount': amount * 100,
      'currency': 'BHD',
      'order_id': _orderId,
      'name': 'Local Skill Share',
      'description': 'Service Payment',
    });
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String signature,
  }) async {
    await http.post(
      Uri.parse(
        'https://razorpay-backend-1-m8ss.onrender.com/verify-payment',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderId': _orderId,
        'paymentId': paymentId,
        'signature': signature,
        'requestId': _requestId,
      }),
    );
  }

  void dispose() {
    _razorpay.clear();
  }
}
