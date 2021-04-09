import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:scoopr/datamodels/nearbydriver.dart';
import 'package:scoopr/helpers/firehelper.dart';
import 'dart:typed_data';

class MapTab extends StatefulWidget{
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab>{
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor nearbyIcon;
  
  void createMarker(){
    if(nearbyIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(1,1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/images/ice-cream-truck-blue.png').then((icon){
        nearbyIcon = icon;
      });
      
    }
  }

  Position currentPosition;
  void setupPositionLocator() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 15);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    startGeofireListener();
  }

  // Start map at the University of Guelph
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(43.53281, -80.22616),
    zoom: 14.5,
  );

  bool nearbyDriverKeysLoaded = false;
  bool truckInArea = false;

  void startGeofireListener(){
    Geofire.initialize('driversAvailable');

    // Radius of 20km
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 20).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            FireHelper.nearbyDriverList.add(nearbyDriver);
            if(nearbyDriverKeysLoaded){
              updateDriversOnMap();
            }

            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
          // Update your key's location
            NearbyDriver nearbyDriver = NearbyDriver();
            nearbyDriver.key = map['key'];
            nearbyDriver.latitude = map['latitude'];
            nearbyDriver.longitude = map['longitude'];

            FireHelper.updateNearbyLocation(nearbyDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
          // All Intial Data is loaded
            if(FireHelper.nearbyDriverList.length > 0){
              truckInArea = true;
            }
            nearbyDriverKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }
    });
  }


  Set<Marker> _Markers = {};
  void updateDriversOnMap(){
    setState((){
      _Markers.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();
    for(NearbyDriver driver in FireHelper.nearbyDriverList){
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: nearbyIcon,
        rotation: FireHelper.generateRandomNumber(360)
      );

      tempMarkers.add(thisMarker);
    }

    setState((){
      _Markers = tempMarkers;
    });
  }


  @override
  Widget build(BuildContext context) {
    createMarker();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(top: 30),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: initialLocation,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
              mapController = controller;
              setupPositionLocator();
            },
            markers: _Markers
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 5),
            child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.indigoAccent,
            ),
            child: Text("Scoop Scan"),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'SCOOP ALERT',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Text(truckInArea ? 'Theres a truck in your area!' : 'Theres no trucks in your area, please come back later!'),
                      actions: <Widget> [ElevatedButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      ]
                    );
                  }
              );
            })
          )
        ]
      )
    );
  }
}