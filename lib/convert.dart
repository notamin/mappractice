import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class convertlatlngtoaddress extends StatefulWidget {
  const convertlatlngtoaddress({super.key});

  @override
  State<convertlatlngtoaddress> createState() => _convertlatlngtoaddressState();
}

class _convertlatlngtoaddressState extends State<convertlatlngtoaddress> {
  String stAddress='',stAd='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAddress,style: TextStyle(fontSize: 40,color: Colors.black),),
          Text(stAd,style: TextStyle(fontSize: 40,color: Colors.black),),
          GestureDetector(
            onTap: ()async{
              List<Placemark> placemarks = await
              placemarkFromCoordinates(
                  31.582045,74.329376);
              List<Location> locations = await
              locationFromAddress(
                  "Pakistan");
            setState(() {
              stAddress =' ${locations.last.longitude.toString()} ${locations.last.latitude.toString()}';
              stAd = placemarks.reversed.last.country.toString();
            });
              },
            child: Container(
              height: 40,
              width: double.infinity,
              color: Colors.cyan,
              child: Center(child: Text('Convert')),
            ),
          )
        ],
      ),
    );
  }
}
