import 'package:flutter/material.dart';
import '../models/farm_model.dart';

class FarmHeader extends StatelessWidget {
  final Farm farm;

  const FarmHeader({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FarmImage(farm: farm),
              const SizedBox(width: 16),
              FarmDetails(farm: farm),
            ],
          ),
        ],
      ),
    );
  }
}

class FarmImage extends StatelessWidget {
  final Farm farm;

  const FarmImage({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          farm.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.store,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}

class FarmDetails extends StatelessWidget {
  final Farm farm;

  const FarmDetails({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            farm.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          FarmLocation(farm: farm),
          const SizedBox(height: 8),
          FarmMetadata(farm: farm),
        ],
      ),
    );
  }
}

class FarmLocation extends StatelessWidget {
  final Farm farm;

  const FarmLocation({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 6),
        Text(
          '${farm.distance.toStringAsFixed(1)} km • ${farm.location}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class FarmMetadata extends StatelessWidget {
  final Farm farm;

  const FarmMetadata({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FarmRatingBadge(farm: farm),
        const SizedBox(width: 16),
        FarmCategoryBadge(farm: farm),
      ],
    );
  }
}

class FarmRatingBadge extends StatelessWidget {
  final Farm farm;

  const FarmRatingBadge({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 191, 0, 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber[700],
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            farm.rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.amber[800],
            ),
          ),
        ],
      ),
    );
  }
}

class FarmCategoryBadge extends StatelessWidget {
  final Farm farm;

  const FarmCategoryBadge({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1), // Updated to withValues for precision
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_outlined,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            farm.category,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
