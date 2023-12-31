import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _buildCameraPosition() {
    if (latitude != null && longitude != null) {
      return CameraPosition(
        target: LatLng(latitude!, longitude!),
        zoom: 14.4746,
      );
    } else {
      return CameraPosition(
        target:
            LatLng(37.42796133580664, -122.085749655962), // Default location
        zoom: 14.4746,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  double? latitude;
  double? longitude;
  Set<Marker> markers = {};
  String? selectedMarkerCoordinates; // Store selected marker coordinates
  geolocator.LocationAccuracy _desiredAccuracy =
      geolocator.LocationAccuracy.best;

  // Function to handle map tap and add a marker
  void _onMapTapped(LatLng latLng) {
    setState(() {
      markers.clear(); // Clear previous markers (if any)
      markers.add(
        Marker(
          markerId: MarkerId("user_location"),
          position: latLng,
          infoWindow: InfoWindow(
            title: "Marked Location",
            snippet: "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}",
          ),
        ),
      );
      selectedMarkerCoordinates =
          "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}";
    });
    print(latLng);
  }

  Future<void> getLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: _desiredAccuracy,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 200, // Reduce the map height
              child: Expanded(
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _buildCameraPosition(),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: markers,
                  onTap: _onMapTapped,
                  myLocationEnabled: true, // Enable the MyLocationButton
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              selectedMarkerCoordinates ?? "Mark a location on the map",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
