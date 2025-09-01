import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  void _showEditReviewDialog(BuildContext context, Review review, int index) {
    final controller = TextEditingController(text: review.comment);
    int rating = review.rating;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Rating:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: rating,
                  items: List.generate(
                    5,
                    (i) =>
                        DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                  ),
                  onChanged: (val) {
                    if (val != null) rating = val;
                  },
                ),
                _buildStars(rating),
              ],
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Review'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _reviews[index] = Review(
                  userName: review.userName,
                  rating: rating,
                  comment: controller.text,
                  date: DateTime.now(),
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Review updated!')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteReview(int index) {
    setState(() {
      _reviews.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review deleted!')));
  }

  int _currentPage = 0;
  final int _reviewsPerPage = 5;
  final List<Review> _reviews = [
    Review(
      userName: 'Alice',
      rating: 5,
      comment: 'Excellent service and fresh products!',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Review(
      userName: 'Bob',
      rating: 4,
      comment: 'Good quality, but delivery was late.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _selectedRating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addReview() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _reviews.insert(
          0,
          Review(
            userName: 'You',
            rating: _selectedRating,
            comment: _commentController.text,
            date: DateTime.now(),
          ),
        );
        _commentController.clear();
        _selectedRating = 5;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review submitted!')));
    }
  }

  double _averageRating() {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummary(),
          Expanded(child: _buildReviewsList()),
          _buildReviewForm(),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    final avg = _averageRating();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Average Rating: ${avg.toStringAsFixed(1)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          _buildStars(avg.round()),
          const Spacer(),
          Text('${_reviews.length} reviews'),
        ],
      ),
    );
  }

  Widget _buildReviewsList() {
    if (_reviews.isEmpty) {
      return const Center(child: Text('No reviews yet.'));
    }
    final start = _currentPage * _reviewsPerPage;
    final end = (_currentPage + 1) * _reviewsPerPage;
    final pageReviews = _reviews.sublist(
      start,
      end > _reviews.length ? _reviews.length : end,
    );
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: pageReviews.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              final review = pageReviews[index];
              final isOwnReview = review.userName == 'You';
              return Semantics(
                label: 'Review by ${review.userName}',
                child: ListTile(
                  leading: CircleAvatar(child: Text(review.userName[0])),
                  title: Row(
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      _buildStars(review.rating),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.comment),
                      Text(
                        _formatDate(review.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: isOwnReview
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit review',
                              onPressed: () => _showEditReviewDialog(
                                context,
                                review,
                                start + index,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete review',
                              onPressed: () => _deleteReview(start + index),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          ),
        ),
        if (_reviews.length > _reviewsPerPage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                ),
                Text(
                  'Page ${_currentPage + 1} of ${(_reviews.length / _reviewsPerPage).ceil()}',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: end < _reviews.length
                      ? () => setState(() => _currentPage++)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReviewForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Your Rating:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedRating,
                  items: List.generate(
                    5,
                    (i) =>
                        DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                  ),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRating = val);
                  },
                ),
                _buildStars(_selectedRating),
              ],
            ),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your review';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _addReview,
                child: const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class Review {
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
