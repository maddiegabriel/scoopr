import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';

// Remove from global
User currUser = FirebaseAuth.instance.currentUser;

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
            children: [
              Text("Welcome " + currUser.displayName),
              ElevatedButton(
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