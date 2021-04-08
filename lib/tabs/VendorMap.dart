import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class VendorMapTab extends StatefulWidget{
  @override
  _VendorMapTabState createState() => _VendorMapTabState();
}

class _VendorMapTabState extends State<VendorMapTab>{
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  Position currentPosition;
  void getCurrentPosition() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }


  // Start map at the University of Guelph
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(43.53281, -80.22616),
    zoom: 14.5,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();

          },
        )
      ]
    );
  }
}