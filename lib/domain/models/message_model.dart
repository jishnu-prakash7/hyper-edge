class MessageModel {
  final String senderId;
  final String recieverId;
  final String message;
  final DateTime creartedAt;
  final DateTime updatedAt;

  MessageModel({
    required this.creartedAt,
    required this.updatedAt,
    required this.message,
    required this.senderId,
    required this.recieverId,
  });
}
