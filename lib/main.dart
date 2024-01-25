import 'package:flutter/material.dart';
import 'package:mappractice/HomeScreen.dart';
import 'package:mappractice/convert.dart';
import 'package:mappractice/getUserCurrentAddress.dart';
import 'package:mappractice/googleplaceapiscreen.dart';
import 'package:mappractice/newmapway.dart';
import 'package:mappractice/polylineroute.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewMap(),//different pages i don't add navigation
      //so depond on functionality go to other pages read page names
    );
  }
}
