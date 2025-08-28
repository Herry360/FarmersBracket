import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({Key? key}) : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _pickedLocation;
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(-25.5657, 30.5286);

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    // Use _mapController to animate camera to picked location
    _mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 8),
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('picked_location'),
                  position: _pickedLocation!,
                  infoWindow: const InfoWindow(title: 'Picked Location'),
                ),
              },
        onTap: _onTap,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: _pickedLocation == null
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.check),
              label: const Text('Confirm'),
              onPressed: () {
                Navigator.pop(context, _pickedLocation);
              },
            ),
    );
  }
}
