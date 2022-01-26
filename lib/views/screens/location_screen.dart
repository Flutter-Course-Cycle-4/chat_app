import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = 'location';
  @override
  State<LocationScreen> createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition? cameraPosition;
  LatLng? currentLatLang;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final _locationData = await Geolocator.getCurrentPosition();
    cameraPosition = CameraPosition(
      target: LatLng(_locationData.latitude, _locationData.longitude),
      zoom: 19,
    );
    currentLatLang = LatLng(_locationData.latitude, _locationData.longitude);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: cameraPosition == null
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: cameraPosition!,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onCameraMove: (position) {
                    setState(() {
                      currentLatLang = LatLng(
                          position.target.latitude, position.target.longitude);
                    });
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
