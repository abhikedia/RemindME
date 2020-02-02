//import 'package:flutter/material.dart';
//import './homepage.dart';
//
//void main() {
//  runApp(Start());
//}
//
//class Start extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: "RemindME",
//      debugShowCheckedModeBanner: false,
//      home: new Container(
//        child: HomePage(),
//      ),
//    );
//  }
//}

import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController mapController;
  Map<String, double> currentLocation = new Map();

  //StreamSubscription<Map<String, double>> locationSubscription;
  var location = new Location();
  String error;

  @override
  void initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState();
    location.onLocationChanged().listen((LocationData current_Location) {
      currentLocation['latitude'] = current_Location.latitude;
      currentLocation['longitude'] = current_Location.longitude;
    });
//    locationSubscription = location.onLocationChanged().listen((Map<String, double> result) {
//        setState(() {
//        currentLocation = result;
//      });
//    });
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
//        body: GoogleMap(
//          onMapCreated: _onMapCreated,
//          initialCameraPosition: CameraPosition(
//            target: _center,
//            zoom: 11.0,
//          ),
//        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Lat/Lng:${currentLocation['latitude']}/${currentLocation['longitude']}',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initPlatformState() async {
    LocationData my_location;
    try {
      my_location = await location.getLocation();
      print(my_location.latitude);
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission denied';
      else if (e.code == 'PERMISSSION_DENIED_NEVER_ASK')
        error = 'Permission not granted. Please grant from app settings.';
      my_location = null;
    }
    setState(() {
      currentLocation['latitude'] = my_location.latitude;
      currentLocation['longitude'] = my_location.longitude;
    });
  }
}
