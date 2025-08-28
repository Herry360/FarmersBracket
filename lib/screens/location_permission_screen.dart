import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionScreen extends StatelessWidget {
  final VoidCallback onNext;
  const LocationPermissionScreen({Key? key, required this.onNext}) : super(key: key);

  Future<void> _requestPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required to continue.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Permission')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Allow Location Access'),
          onPressed: () => _requestPermission(context),
        ),
      ),
    );
  }
}
