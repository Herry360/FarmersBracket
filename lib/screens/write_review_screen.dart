import 'package:flutter/material.dart';

// Screen for composing a product review
class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement review form with rating, text, and photo upload
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: const Center(child: Text('Review writing coming soon!')),
    );
  }
}
