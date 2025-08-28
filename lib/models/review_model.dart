class ReviewModel {
  final String id;
  final String userId;
  final String targetId; // productId or farmId
  final String targetType; // 'product' or 'farm'
  final int rating; // 1-5
  final String comment;
  final DateTime date;
  final List<String> imageUrls;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.rating,
    required this.comment,
    required this.date,
    this.imageUrls = const [],
  });
}
