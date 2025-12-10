import 'package:cloud_firestore/cloud_firestore.dart';

class HelpRequest {
  final String id;
  final String title;
  final String description;
  final double price;
  final String userId;
  final Timestamp createdAt;

  HelpRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  factory HelpRequest.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HelpRequest(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
