import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/supabase_service.dart';
import '../models/farm_model.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(-25.5657, 30.5286); // Example: Mpumalanga
  final SupabaseService _supabaseService = SupabaseService();
  List<Farm> _farms = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchFarmsAndMarkers();
  }

  Future<void> _fetchFarmsAndMarkers() async {
    // Replace with actual userId logic
    String userId = "demo";
    final farmMaps = await _supabaseService.fetchFarms(userId);
    _farms = farmMaps.map((f) => Farm(
      id: f['id'] ?? '',
      name: f['name'] ?? '',
      description: f['description'] ?? '',
      imageUrl: f['imageUrl'] ?? '',
      rating: (f['rating'] ?? 0).toDouble(),
      distance: (f['distance'] ?? 0).toDouble(),
      location: f['location'] ?? '',
      category: f['category'] ?? '',
      products: [],
      price: (f['price'] ?? 0).toDouble(),
      isFavorite: f['isFavorite'] ?? false,
    )).toList();

    // Example: expect location as "lat,lng" string
    for (var farm in _farms) {
      if (farm.location.contains(',')) {
        final parts = farm.location.split(',');
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          _markers.add(Marker(
            markerId: MarkerId(farm.id),
            position: LatLng(lat, lng),
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
      }
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
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newLatLng(_initialPosition),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 8,
              ),
              markers: _markers,
              onLongPress: _addMarker,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.hybrid,
              compassEnabled: true,
              zoomControlsEnabled: false,
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_location_alt),
        onPressed: () {
          _addMarker(_initialPosition);
        },
      ),
    );
  }
}