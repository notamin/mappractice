import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
class GooglePlaceApiScreen extends StatefulWidget {
  const GooglePlaceApiScreen({super.key});

  @override
  State<GooglePlaceApiScreen> createState() => _GooglePlaceApiScreenState();
}

class _GooglePlaceApiScreenState extends State<GooglePlaceApiScreen> {
  TextEditingController _controller = TextEditingController();
  var uuid= Uuid();
  List<dynamic> _placesList=[];
  String _sessionToken='11223344';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }
  void onChange(){
    if(_sessionToken == null){
      setState(() {
        _sessionToken=uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }
  Future<void> getSuggestion(String input) async {
    String API_KEY = 'AIzaSyDU9F8tJtWcIMcWLqyBacrrw02KQK1cbdQ';
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    print('data');
    print(data);
  if(response.statusCode == 200){
setState(() {
  _placesList = jsonDecode(response.body.toString()) ['predictions'];

});

  }else{
    throw Exception('Failed to Load Data');
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Google Search Place Api'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child:Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search Location'
              ),
            ),
            Expanded(child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(_placesList[index]['description']),
                  );

            })
            )

          ],
        ),
      ),
    );
  }
}
