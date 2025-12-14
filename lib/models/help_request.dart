import 'package:cloud_firestore/cloud_firestore.dart';

class HelpRequest {
  final String id;
  final String title;
  final String description;
  final double price;
  final String userId;
  final Timestamp createdAt;
  final String status;       // pending / accepted / completed
  final String? acceptedBy;

  HelpRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.userId,
    required this.createdAt,
    required this.status,
    required this.acceptedBy,
  });

  factory HelpRequest.fromMap(Map<String, dynamic> map, String id) {
    return HelpRequest(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      status: map['status'] ?? 'pending',
      acceptedBy: map['acceptedBy'],
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
    };
  }

  HelpRequest copyWith({
    String? title,
    String? description,
    double? price,
    String? status,
    String? acceptedBy,
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
    );
  }
}
