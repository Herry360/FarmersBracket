class SupportTicket {
  final String id;
  final String orderId;
  final String userId;
  final String issueType; // e.g., Damaged Item, Late Delivery, Product Question
  final String status; // Submitted, In Review, Resolved, Refund Issued
  final DateTime createdAt;
  final List<SupportMessage> messages;
  final List<String> affectedProductIds; // For item-specific issues
  final String? description;
  final String? imageUrl;

  SupportTicket({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.issueType,
    required this.status,
    required this.createdAt,
    required this.messages,
    this.affectedProductIds = const [],
    this.description,
    this.imageUrl,
  });
}

class SupportMessage {
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isFromSupport;

  SupportMessage({
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isFromSupport,
  });
}
