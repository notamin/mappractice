import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 14,
  );

  List<Marker> _marker = [];
  List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.582045, 74.329376),
      infoWindow: InfoWindow(title: 'My Position'),
    ),
    // Add more markers if needed
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  // Function to handle FAB click
  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_marker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),

        // Add Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: _goToMyLocation,

          child: Icon(Icons.my_location),
        ),
      ),
    );
  }
}
