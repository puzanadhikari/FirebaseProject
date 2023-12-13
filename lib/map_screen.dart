import 'dart:async';
import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  Location location = Location();
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     var userLocation = await location.getLocation();
  //     setState(() {
  //       currentLocation = userLocation;
  //     });
  //   } catch (e, stackTrace) {
  //     log("Error getting location: $e");
  //     log("Stack trace: $stackTrace");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error getting location: $e'),
  //       ),
  //     );
  //   }
  // }
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),

    );
  }
}
