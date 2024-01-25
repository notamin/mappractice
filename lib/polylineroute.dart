import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mappractice/constants.dart';

class PolylineRoute extends StatefulWidget {
  const PolylineRoute({super.key});

  @override
  State<PolylineRoute> createState() => _PolylineRouteState();
}

class _PolylineRouteState extends State<PolylineRoute> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng source = LatLng(37.33500926, -122.03272188);
  LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinated=[];
  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult results = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(source.latitude, source.longitude),
    PointLatLng(destination.latitude, destination.longitude)
    ) as PolylineResult;

    if(results.points.isNotEmpty){
      results.points.forEach((PointLatLng point)=>
          polylineCoordinated.add(
        LatLng(point.latitude, point.longitude)
      ));
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Route'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: source, zoom: 12),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinated,
            color: Colors.orange
          ),
        },
        markers: {
          Marker(
            markerId: MarkerId('source'),
            position: source,
          ),
          Marker(
            markerId: MarkerId('destination'),
            position: destination,
          ),
        },
      ),

    );
  }
}
