import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';
import '../providers/reviews_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;
  bool _submitted = false;

  void _submit() {
    setState(() {
      _submitted = true;
    });

    final review = ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: "demo_user", // Replace with actual user ID from auth provider
      targetId: "feedback", // Use a special targetId for general feedback
      targetType: "general",
      rating: _rating.round(),
      comment: _feedbackController.text.trim(),
      date: DateTime.now(),
      imageUrls: [],
    );
    ref.read(reviewsProvider.notifier).addReview(review);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _submitted = false;
        _feedbackController.clear();
        _rating = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback & Suggestions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rate your experience:', style: TextStyle(fontSize: 16)),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating == 0 ? 'No rating' : _rating.toString(),
              onChanged: (v) => setState(() => _rating = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your feedback or suggestion',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitted ? null : _submit,
              child: Text(_submitted ? 'Submitting...' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
