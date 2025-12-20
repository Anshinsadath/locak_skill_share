import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../models/help_request.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/services/request_service.dart';
import '../../../core/services/chat_service.dart';
import '../../auth/state/user_provider.dart';
import '../../request/state/user_requests_provider.dart';
import '../../request/state/accepted_requests_provider.dart';

class RequestDetailsPage extends ConsumerStatefulWidget {
  final HelpRequest request;

  const RequestDetailsPage({super.key, required this.request});

  @override
  ConsumerState<RequestDetailsPage> createState() =>
      _RequestDetailsPageState();
}

class _RequestDetailsPageState extends ConsumerState<RequestDetailsPage> {
  late PaymentService paymentService;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    paymentService = PaymentService();
  }

  @override
  void dispose() {
    paymentService.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // HELPERS
  // --------------------------------------------------

  bool get isPaid => widget.request.paymentStatus == 'paid';

  bool get isPaymentExpired {
    if (widget.request.paymentExpiryAt == null) return false;
    return DateTime.now().isAfter(
      widget.request.paymentExpiryAt!.toDate(),
    );
  }

  // --------------------------------------------------
  // PAYMENT FLOW
  // --------------------------------------------------
  Future<void> startPayment() async {
    setState(() => loading = true);

    try {
      final res = await http.post(
        Uri.parse(
            "https://interramal-launa-unled.ngrok-free.dev/create-order"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "requestId": widget.request.id,
          "amount": widget.request.price,
        }),
      );

      if (res.statusCode != 200) {
        throw Exception("Failed to create order");
      }

      final data = jsonDecode(res.body);

      paymentService.init(
  orderId: data['orderId'],
  requestId: widget.request.id,
  onSuccess: (paymentId, signature) async {
    await paymentService.verifyPayment(
      paymentId: paymentId,
      signature: signature,
    );

    // 🔥 FORCE UI REFRESH (THIS IS STEP 11)
    ref.invalidate(userRequestsProvider);
    ref.invalidate(acceptedRequestsProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful")),
      );

      // ⬅ Go back so refreshed lists load
      Navigator.pop(context);
    }
  },
  onError: (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  },
);

      paymentService.openCheckout(widget.request.price.toInt());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseUserProvider).value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    final requestService = ref.read(requestServiceProvider);
    final chatService = ref.read(chatServiceProvider);

    final isOwner = user.uid == widget.request.userId;
    final isAccepted = widget.request.status == 'accepted';
    final isHelper = widget.request.acceptedBy == user.uid;

    final paidAt = widget.request.paidAt != null
        ? DateFormat.yMMMd().add_jm().format(
              widget.request.paidAt!.toDate(),
            )
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Request Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- TITLE ----------------
            Text(
              widget.request.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            Text(widget.request.description),

            const SizedBox(height: 12),
            Text(
              "Price: ${widget.request.price} BHD",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            // ---------------- PAYMENT STATUS ----------------
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPaid ? "PAID" : "UNPAID",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (paidAt != null) ...[
                  const SizedBox(width: 10),
                  Text(
                    "Paid on $paidAt",
                    style: const TextStyle(fontSize: 13),
                  ),
                ]
              ],
            ),

            // 🔥 PAYMENT EXPIRY MESSAGE
            if (widget.request.paymentExpiryAt != null &&
                isAccepted &&
                !isPaid)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  isPaymentExpired
                      ? "❌ Payment time expired"
                      : "⏳ Payment expires on ${DateFormat.yMMMd().add_jm().format(
                          widget.request.paymentExpiryAt!.toDate(),
                        )}",
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        isPaymentExpired ? Colors.red : Colors.orange,
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // ---------------- ACCEPT REQUEST ----------------
            if (!isOwner && !isAccepted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await requestService.acceptRequest(
                      requestId: widget.request.id,
                      helperId: user.uid,
                    );

                    final chatId =
                        await chatService.createOrGetChat(
                      widget.request.userId,
                      user.uid,
                    );

                    context.go('/chat?chatId=$chatId');
                  },
                  child: const Text("Accept Request"),
                ),
              ),

            // ---------------- PAY BUTTON ----------------
            if (isOwner &&
                isAccepted &&
                !isPaid &&
                !isPaymentExpired)
              SizedBox(
                width: double.infinity,
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: startPayment,
                        child: const Text("Pay Now"),
                      ),
              ),

            // ❌ CHAT BLOCKED IF EXPIRED
            if (isPaymentExpired)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  "Chat disabled. Payment expired.",
                  style: TextStyle(color: Colors.red),
                ),
              ),

            // ---------------- OPEN CHAT ----------------
            if (isAccepted &&
                (isOwner || isHelper) &&
                isPaid)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final otherUserId = isOwner
                        ? widget.request.acceptedBy!
                        : widget.request.userId;

                    final chatId =
                        await chatService.createOrGetChat(
                      user.uid,
                      otherUserId,
                    );

                    context.go('/chat?chatId=$chatId');
                  },
                  child: const Text("Open Chat"),
                ),
              ),

            if (isPaid)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Payment Completed"),
                ),
              ),

            if (isAccepted && !isPaid && !isPaymentExpired)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "⚠️ Chat will be unlocked after payment is completed",
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
