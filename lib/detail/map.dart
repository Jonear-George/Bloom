// ignore_for_file: library_private_types_in_public_api, prefer_collection_literals, avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapWithFirebaseMarkers extends StatefulWidget {
  const MapWithFirebaseMarkers({super.key});

  @override
  _MapWithFirebaseMarkersState createState() => _MapWithFirebaseMarkersState();
}

class _MapWithFirebaseMarkersState extends State<MapWithFirebaseMarkers> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    fetchMarkerLocations();
  }

  Future<void> fetchMarkerLocations() async {
    // Fetch marker locations from Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('markers').get();

    querySnapshot.docs.forEach((doc) {
      double lat = doc.data()['latitude'];
      double lng = doc.data()['longitude'];
      String markerId = doc.id;

      Marker marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: 'Marker $markerId'),
      );

      setState(() {
        markers.add(marker);
      });
    });

    // Adding the specific marker with coordinates 17.964359706942844, 102.60680632739421
    Marker specificMarker = Marker(
      markerId: MarkerId('SpecificMarker'),
      position: LatLng(17.964359706942844, 102.60680632739421),
      infoWindow: InfoWindow(title: 'Specific Marker'),
    );

    setState(() {
      markers.add(specificMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with Firebase Markers'),
      ),
      body: Container(
        height: 300,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0), // Set initial camera position
            zoom: 15.0,
          ),
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }
}
