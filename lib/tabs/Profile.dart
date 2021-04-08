import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:scoopr/signIn.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileTab extends StatelessWidget{
  getDisplayName() {
    User currUser = FirebaseAuth.instance.currentUser;
    print('inside getDisplayName');
    if (currUser != null) {
      return "CUSTOMER " + currUser.displayName;
    } else {
      return "CUSTOMER HOME Welcome!!";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(getDisplayName(), style: TextStyle(
              color: Colors.black
          )),
          backgroundColor: Colors.white,
        ),
        body: Column(
            children: [
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
    );
  }
}