import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_service.dart';
// ...existing code...
import '../models/farm_model.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(-25.5657, 30.5286); // Example: Mpumalanga
  // ...existing code...
  List<Farm> _farms = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    _fetchFarmsAndMarkers();
  }

  void _fetchUserLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _mapController.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
        _markers.add(Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ));
      });
    }
  }

  Future<void> _fetchFarmsAndMarkers() async {
    // Replace with actual userId logic
  // ...existing code...
  // ...existing code...
    _farms = [
      const Farm(
        id: '1',
        name: 'Green Valley',
        description: 'Organic farm',
        imageUrl: '',
        rating: 4.5,
        distance: 2.0,
        latitude: -25.5657,
        longitude: 30.5286,
        story: 'Green Valley is dedicated to organic farming and sustainability.',
        practiceLabels: ['Organic', 'Sustainable'],
        imageUrls: ['https://images.unsplash.com/photo-1464983953574-0892a716854b'],
        category: 'Vegetables',
        products: [],
        price: 50.0,
        isFavorite: false, location: null,
      ),
      const Farm(
        id: '2',
        name: 'Sunny Acres',
        description: 'Fruit farm',
        imageUrl: '',
        rating: 4.0,
        distance: 5.0,
        latitude: -25.5700,
        longitude: 30.5300,
        story: 'Sunny Acres specializes in fresh fruit and family-owned practices.',
        practiceLabels: ['Family-Owned', 'Fresh'],
        imageUrls: ['https://images.unsplash.com/photo-1506744038136-46273834b3fb'],
        category: 'Fruits',
        products: [],
        price: 30.0,
        isFavorite: true, location: null,
      ),
    ];

    // Example: expect location as "lat,lng" string
    for (var farm in _farms) {
      _markers.add(Marker(
        markerId: MarkerId(farm.id),
        position: LatLng(farm.latitude, farm.longitude),
        infoWindow: InfoWindow(
          title: farm.name,
          snippet: farm.description,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(farm.name.isNotEmpty ? farm.name : 'Farm Details'),
              content: Text(farm.description.isNotEmpty ? farm.description : 'Details for this farm will be shown here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ));
    }
    setState(() {
      _loading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarker(LatLng position) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: 'Custom Marker',
        snippet: '${position.latitude}, ${position.longitude}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Map'),
        actions: [
          Semantics(
            button: true,
            label: 'Go to initial location',
            child: IconButton(
              icon: const Icon(Icons.my_location),
              tooltip: 'Go to initial location',
              onPressed: () {
                _mapController.animateCamera(
                  CameraUpdate.newLatLng(_initialPosition),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Moved to initial location.')),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Semantics(
                    label: 'Farm map',
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 8,
                      ),
                      markers: _markers,
                      onLongPress: (position) {
                        _addMarker(position);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Custom marker added at {position.latitude}, {position.longitude}')),
                        );
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.hybrid,
                      compassEnabled: true,
                      zoomControlsEnabled: false,
                    ),
                  ),
                  Positioned(
                    bottom: 32,
                    left: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Find Farms Near Me & Continue'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Onboarding complete! Welcome.')),
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pushReplacementNamed(context, '/home');
                        });
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: Semantics(
        button: true,
        label: 'Add marker at initial location',
        child: FloatingActionButton(
          tooltip: 'Add marker at initial location',
          onPressed: () {
            _addMarker(_initialPosition);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Marker added at initial location.')),
            );
          },
          child: const Icon(Icons.add_location_alt),
        ),
      ),
    );
  }
}