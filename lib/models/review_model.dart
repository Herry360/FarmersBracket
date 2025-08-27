class ReviewModel {
  final String id;
  final String userId;
  final String productId;
  final int rating; // 1-5
  final String comment;
  final DateTime date;
  final String? imageUrl;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.date,
    this.imageUrl,
  });
}
