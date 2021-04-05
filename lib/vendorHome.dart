import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorHomePage extends StatelessWidget{
  // Think this needs to do in an async func because it does not load name dynamically
  // first time after signing up
  getDisplayName() {
    User currUser = FirebaseAuth.instance.currentUser;
    print('inside getDisplayName');
    if(currUser != null) {
      return "VENDOR HOME Welcome " + currUser.displayName;
    } else {
      return "VENDOR HOME Welcome!!";
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text('VENDOR HOME'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
            children: [
              Text(getDisplayName()),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigoAccent,
                  ),
                  onPressed: (){
                    context.read<AuthenticationService>().signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  }, child: Text("Sign Out")
              )
            ]
        )
      )
    );
  }
}