import 'dart:js';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PaymentService {
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
  }

  void openCheckout({
    required int amount,
    required String razorpayKey,
  }) {
    final options = JsObject.jsify({
      'key': razorpayKey,
      'amount': amount * 100,
      'currency': 'BHD',
      'name': 'Local Skill Share',
      'description': 'Service Payment',
      'order_id': _orderId,
      'handler': allowInterop((response) {
        final paymentId = response['razorpay_payment_id'];
        final signature = response['razorpay_signature'];
        _onSuccess(paymentId, signature);
      }),
      'modal': {
        'ondismiss': allowInterop(() {
          _onError('Payment cancelled');
        })
      }
    });

    final razorpay = context['Razorpay'];
    if (razorpay == null) {
      _onError('Razorpay SDK not loaded');
      return;
    }

    final rzp = JsObject(razorpay, [options]);
    rzp.callMethod('open');
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String signature,
  }) async {
    await http.post(
      Uri.parse('https://razorpay-backend-1-m8ss.onrender.com/verify-payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderId': _orderId,
        'paymentId': paymentId,
        'signature': signature,
        'requestId': _requestId,
      }),
    );
  }
}
