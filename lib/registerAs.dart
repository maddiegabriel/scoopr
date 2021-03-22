import 'package:flutter/material.dart';
import 'package:scoopr/signUp.dart';
import 'package:scoopr/vendorSignUp.dart';

class RegisterAsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.indigoAccent,
        ),
        // Moves text field above keyboard
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    children: <Widget>[
                      new Image(
                        image: new AssetImage('assets/images/logo.png'),
                        height: 120.0,
                        width: 300.0,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent,
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text("Customer"),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigoAccent,
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VendorSignUpPage()),
                            );
                          },
                          child: Text("Vendor")
                      )
                    ]
                )
            )
        )
    );
  }
}