import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewMap extends StatefulWidget {
  const NewMap({super.key});

  @override
  State<NewMap> createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> {

  //get map controller to access map
  Completer<GoogleMapController> _googleMapController = Completer();
  late CameraPosition _cameraPosition;
  late LatLng _defaultLatLng;
  late LatLng _dragLatLng;
  String draggedAddress= "";
  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }
  _init(){
    _defaultLatLng =LatLng(11, 104);
    _dragLatLng = _defaultLatLng;
    _cameraPosition =  CameraPosition(target: _defaultLatLng,
    zoom: 14.5
    );

    //redirect to my current location
    _getUserCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildbody(),
      floatingActionButton: FloatingActionButton(
        onPressed: ( ){
          _getUserCurrentPosition();
        },
        child: Icon(Icons.location_on_sharp),
      ),
    );
  }

  Widget _buildbody(){
    return Stack(
      children: [
        _getMap(),
        _getCustomPin(),
        _showDraggedAddrss()
      ],
    );
  }

  Widget  _showDraggedAddrss(){
    return SafeArea(
      child: Container(
        width:  MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue
        ),
        child: Center(child:
          Text('$draggedAddress',style: TextStyle(color: Colors.white),),),
      
      ),
    );
  }

  Future _getAddress(LatLng position) async {
    List<Placemark> placemark = await
    placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark address= placemark[0];
   String addressStr = '${address.street},${address.locality},${address.administrativeArea}, ${address.country}';
   setState(() {
     draggedAddress = addressStr;
   });
  }

  Widget _getMap(){
    return
        GoogleMap(
            initialCameraPosition:
            _cameraPosition,
          mapType: MapType.normal,
          onCameraIdle: (){
              //this function will trigger when user dragging on map

            _getAddress(_dragLatLng);
          },
          onCameraMove: (cameraPosition){
              //this function will trigger when user keep dragging on map

            _dragLatLng = cameraPosition.target;
          },
          onMapCreated: (GoogleMapController controller){
              //this function is trigger when map is fully loaded
            if(!_googleMapController.isCompleted){
              //set controler to google map when it is fully loaded
              _googleMapController.complete(controller);
            }

          },
        );

  }

  Widget _getCustomPin(){
    return Center(
      child: Container(
        width: 60,
        child: Image.asset('assets/pin.png'),
      ),
    );

  }
  //get user's current locaation set the camera map to the location
  Future _getUserCurrentPosition() async {
    Position currentPosition = await _determineUserCurrentPosition();
    _gotoSpecificPosition(LatLng
      (currentPosition.latitude,
        currentPosition.longitude)
    );
  }

  Future _gotoSpecificPosition( LatLng position)async{
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position,
      zoom: 14)
    ));

    //every time we dragges pin , it will list down the address here
    await _getAddress(position);
  }

  Future _determineUserCurrentPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnable = await Geolocator.isLocationServiceEnabled();
    //check if user enavle service from location permission
    if(!isLocationServiceEnable){
      print('User don\'t enable location permission');
    }
    locationPermission = await Geolocator.checkPermission();
    if(locationPermission== LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission==LocationPermission.denied){
        print('user Denied location permission ohooooo seeedddd');
      }
    }

    //checck if user denied permission forever
    if(locationPermission == LocationPermission.deniedForever){
      print('User Denied permission forever');
    }
return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  }

}
