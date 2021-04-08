import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoopr/widgets/ConfirmSheet.dart';

class VendorMapTab extends StatefulWidget{
  @override
  _VendorMapTabState createState() => _VendorMapTabState();
}

class _VendorMapTabState extends State<VendorMapTab>{
  String availabilityTitle = 'Go Online';
  Color availabilityColor = Colors.redAccent;
  bool isAvailable = false;

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
          padding: EdgeInsets.only(top: 100),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          height: 80,
          width: double.infinity,
          color: Colors.white
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: availabilityColor,
                ),
                onPressed: (){
                  showModalBottomSheet(isDismissible: false, context: context, builder: (BuildContext context) => ConfirmSheet(
                    title: !isAvailable ? 'GO ONLINE' : 'GO OFFLINE',
                    subtitle: !isAvailable ? 'You are about to become visible to all users' : 'You are able to become invisible to all users',
                    onPressed: (){
                      if(!isAvailable){
                        goOnline();
                        getLocationUpdates();
                        Navigator.pop(context);
                        setState((){
                          availabilityColor = Colors.green;
                          availabilityTitle = 'Go Offline';
                          isAvailable = true;
                        });
                      } else {
                        goOffline();
                        Navigator.pop(context);
                        setState(() {
                          availabilityColor = Colors.redAccent;
                          availabilityTitle = 'Go Online';
                          isAvailable = false;
                        });
                      }
                    },
                  ));
                }, child: Text(availabilityTitle)
              )
            ]
          )
        )
      ]
    );
  }

  DatabaseReference requestRef;
  User currUser = FirebaseAuth.instance.currentUser;
  void goOnline(){
    Geofire.initialize('driversAvailable');
    Geofire.setLocation(currUser.uid, currentPosition.latitude, currentPosition.longitude);

    requestRef = FirebaseDatabase.instance.reference().child('drivers/${currUser.uid}/newrequest');
    requestRef.set('waiting');

    requestRef.onValue.listen((event){

    });
  }

  void goOffline(){
    Geofire.removeLocation(currUser.uid);
    requestRef.onDisconnect();
    requestRef.remove();
    requestRef = null;
  }

  Geolocator geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  void getLocationUpdates(){
    StreamSubscription<Position> vendorMapTabPositionStream;
    vendorMapTabPositionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      currentPosition = position;

      if(isAvailable == true){
        Geofire.setLocation(currUser.uid, position.latitude, position.longitude);
      }
      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

}