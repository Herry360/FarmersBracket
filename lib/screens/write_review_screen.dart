import 'package:flutter/material.dart';
import '../services/image_picker_service.dart';
import '../widgets/rating_bar.dart';

// Screen for composing a product review
class WriteReviewScreen extends StatelessWidget {
  final ImagePickerService _imagePickerService = ImagePickerService();
  WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    int rating = 0;
    String reviewText = '';
    List<String> photos = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rate the product:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Semantics(
                        label: 'Rating bar',
                        child: RatingBar(
                          rating: rating,
                          maxRating: 5,
                          onRatingChanged: (newRating) {
                            rating = newRating;
                            (context as Element).markNeedsBuild();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Your Review',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your review';
                          }
                          reviewText = value;
                          return null;
                        },
                        onChanged: (value) {
                          reviewText = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add photos (optional):',
                        style: TextStyle(fontSize: 16),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          ...photos.map(
                            (path) => Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    path,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    photos.remove(path);
                                    (context as Element).markNeedsBuild();
                                  },
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_a_photo, size: 32),
                            onPressed: () async {
                              final pickedPath = await _imagePickerService
                                  .pickImage();
                              if (pickedPath != null && context.mounted) {
                                photos.add(pickedPath);
                                (context as Element).markNeedsBuild();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Semantics(
                        button: true,
                        label: 'Submit review',
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                rating > 0 &&
                                reviewText.isNotEmpty) {
                              // Mock review submission logic
                              // Replace with your backend/provider call as needed
                              print(
                                'Review submitted: rating=$rating, text=$reviewText, photos=$photos',
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Review submitted: $reviewText',
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            } else if (rating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a rating.'),
                                ),
                              );
                            } else if (reviewText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter your review.'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Submit Review'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
