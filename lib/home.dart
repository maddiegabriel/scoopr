import 'package:flutter/material.dart';
import 'package:scoopr/authentication_service.dart';
import 'package:provider/provider.dart';

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
              Text("HOME"),
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