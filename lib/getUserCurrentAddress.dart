import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GetUserCurrentAddress extends StatefulWidget {
  const GetUserCurrentAddress({super.key});

  @override
  State<GetUserCurrentAddress> createState() => _GetUserCurrentAddressState();
}

class _GetUserCurrentAddressState extends State<GetUserCurrentAddress> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 14,
  );

  List<Marker> _marker = [];
  List<Marker> _list =  [
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
    controller.animateCamera(CameraUpdate.newCameraPosition(
        _kGooglePlex));
  }

  Future<Position> getusercurrentlocation() async{
    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace) {
print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
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
          onPressed: (){
            getusercurrentlocation().then((value) async {
              print('my current location');
              print(value.latitude.toString()+' '+ value.longitude.toString());

              _marker.add(
                  Marker(markerId: MarkerId('2'),
                      position: LatLng(value.latitude,value.longitude),
                    infoWindow: InfoWindow(
                      title: 'My Homee)'
                    )
                  )
              );
              CameraPosition cameraPosition=CameraPosition(
                  zoom: 14,target: LatLng(value.latitude,value.longitude));

              final GoogleMapController controller=await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {

            });

            });

          },

          child: Icon(Icons.my_location),
        ),
      ),
    );
  }
}
