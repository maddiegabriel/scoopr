import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/signIn.dart';

class HomePage extends StatelessWidget {
  getDisplayName() {
    User currUser = FirebaseAuth.instance.currentUser;
    print('inside getDisplayName');
    if (currUser != null) {
      return "CUSTOMER HOME Welcome " + currUser.displayName;
    } else {
      return "CUSTOMER HOME Welcome!!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CUSTOMER HOME'),
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
                      onPressed: () {
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