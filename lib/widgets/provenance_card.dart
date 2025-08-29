import 'package:flutter/material.dart';

class ProvenanceCard extends StatelessWidget {
  final String farmName;
  final String farmLogoUrl;
  final double distanceKm;
  final String farmerName;

  const ProvenanceCard({
    super.key,
    required this.farmName,
    required this.farmLogoUrl,
    required this.distanceKm,
    required this.farmerName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/farmProfile', arguments: farmName);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(farmLogoUrl),
                radius: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Farmer: $farmerName'),
                    Text('Distance: ${distanceKm.toStringAsFixed(1)} km'),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
