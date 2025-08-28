class IssueReport {
  final String id;
  final String userId;
  final String orderId;
  final String productId;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final String issueType;
  final List<String> photoEvidenceUrls;
  final String? relatedOrderId;
  final double? resolvedCreditAmount;

  IssueReport({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.description,
    this.imageUrls = const [],
    required this.createdAt,
    required this.issueType,
    this.photoEvidenceUrls = const [],
    this.relatedOrderId,
    this.resolvedCreditAmount,
  });
}
