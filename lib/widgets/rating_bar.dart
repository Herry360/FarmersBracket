import 'package:flutter/material.dart';

// Widget for displaying and setting star ratings
class RatingBar extends StatelessWidget {
  final int rating;
  final int maxRating;
  final void Function(int)? onRatingChanged;

  const RatingBar({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxRating, (index) {
        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}
