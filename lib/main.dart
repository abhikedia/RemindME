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
import 'dart:math';
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

//LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static final LatLng center = const LatLng(-33.86711, 151.1947171);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 2;

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 11.0,
            ),
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            markers: Set<Marker>.of(markers.values)
        ),
        floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(currentLocation['latitude'],
                        currentLocation['longitude']),
                    zoom: 20.0),
              ),
            );
          },
        ),
      ),
    );
  }


  void initPlatformState() async {
    LocationData my_location;
    try {
      my_location = await location.getLocation();
      print(my_location.latitude);
      print(my_location.longitude);
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
      markers[MarkerId('1')] = Marker(
        markerId: MarkerId('1'),
        position: LatLng(
            my_location.latitude, my_location.longitude
        ),
      );
    });
  }
}