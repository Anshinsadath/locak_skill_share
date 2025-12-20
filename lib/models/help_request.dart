import 'package:cloud_firestore/cloud_firestore.dart';

class HelpRequest {
  final String id;
  final String title;
  final String description;
  final double price;
  final String userId;
  final Timestamp createdAt;
  final String status;
  final String? acceptedBy;

  // 💳 PAYMENT
  final String paymentStatus; // unpaid | paid
  final Timestamp? paidAt;
  final String? paymentIntentId;

  // ⏳ PAYMENT EXPIRY
  final Timestamp? paymentExpiryAt;

  HelpRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.userId,
    required this.createdAt,
    required this.status,
    required this.acceptedBy,
    required this.paymentStatus,
    required this.paidAt,
    required this.paymentIntentId,
    required this.paymentExpiryAt,
  });

  factory HelpRequest.fromMap(Map<String, dynamic> map, String id) {
    return HelpRequest(
      id: id,
      title: map['title'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      userId: map['userId'],
      createdAt: map['createdAt'],
      status: map['status'],
      acceptedBy: map['acceptedBy'],
      paymentStatus: map['paymentStatus'] ?? 'unpaid',
      paidAt: map['paidAt'],
      paymentIntentId: map['paymentIntentId'],
      paymentExpiryAt: map['paymentExpiryAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'userId': userId,
      'createdAt': createdAt,
      'status': status,
      'acceptedBy': acceptedBy,
      'paymentStatus': paymentStatus,
      'paidAt': paidAt,
      'paymentIntentId': paymentIntentId,
      'paymentExpiryAt': paymentExpiryAt,
    };
  }
  HelpRequest copyWith({
  String? title,
  String? description,
  double? price,
  String? status,
  String? acceptedBy,
  String? paymentStatus,
  Timestamp? paidAt,
  Timestamp? paymentExpiryAt,
  String? paymentIntentId,
}) {
  return HelpRequest(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    price: price ?? this.price,
    userId: userId,
    createdAt: createdAt,
    status: status ?? this.status,
    acceptedBy: acceptedBy ?? this.acceptedBy,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    paidAt: paidAt ?? this.paidAt,
    paymentExpiryAt: paymentExpiryAt ?? this.paymentExpiryAt,
    paymentIntentId: paymentIntentId ?? this.paymentIntentId,
  );
}

}
