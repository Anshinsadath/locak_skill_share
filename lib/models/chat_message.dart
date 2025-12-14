class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "senderId": senderId,
      "text": text,
      "timestamp": timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map["id"] ?? "",
      senderId: map["senderId"] ?? "",
      text: map["text"] ?? "",
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(map["timestamp"] ?? 0),
    );
  }
}
