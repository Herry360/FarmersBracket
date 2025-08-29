import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';

class ReviewsState {
  final List<ReviewModel> reviews;
  final bool isLoading;
  final String? error;
  ReviewsState({required this.reviews, required this.isLoading, this.error});
}

class ReviewsNotifier extends StateNotifier<ReviewsState> {
  ReviewsNotifier()
    : super(ReviewsState(reviews: [], isLoading: false, error: null));

  Future<void> loadReviews(String targetId, String targetType) async {
    state = ReviewsState(reviews: state.reviews, isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulate loading reviews
    state = ReviewsState(reviews: [], isLoading: false, error: null);
  }

  void addReview(ReviewModel review) {
    final updated = List<ReviewModel>.from(state.reviews)..add(review);
    state = ReviewsState(reviews: updated, isLoading: false, error: null);
  }
}

final reviewsProvider = StateNotifierProvider<ReviewsNotifier, ReviewsState>((
  ref,
) {
  return ReviewsNotifier();
});
