import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget{
  // Think this needs to do in an async func because it does not load name dynamically
  // first time after signing up
  getDisplayName() {
    User currUser = FirebaseAuth.instance.currentUser;
    if(currUser.displayName != null) {
      return "Welcome " + currUser.displayName;
    } else {
      return "Welcome";
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
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
                  }, child: Text("Sign Out")
              )
            ]
        )
      )
    );
  }
}