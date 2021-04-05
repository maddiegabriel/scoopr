import 'package:flutter/material.dart';
import 'package:scoopr/signIn.dart';
import 'package:scoopr/signUp.dart';
import 'package:scoopr/vendorSignUp.dart';

class RegisterAsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
        // Moves text field above keyboard
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(top: 160.0, bottom: 45.0),
                        child: Image(
                          image: new AssetImage('assets/images/logo.png'),
                          width: 260.0,
                        ),
                      ),
                      Text(
                        "Register as:",
                        style: TextStyle(
                            color: Color(0xff7bc1e4),
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                          child:
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(width: 200, height: 60),
                            child:
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff9CB6E4),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                },
                                child: Text("CUSTOMER"),
                              ),
                          ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                          child:
                          ConstrainedBox(
                              constraints: BoxConstraints.tightFor(width: 200, height: 60),
                              child:
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff9CB6E4),
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => VendorSignUpPage()),
                                      );
                                    },
                                    child: Text("VENDOR")
                                ),
                          ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shadowColor: Colors.white,
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          },
                          child: Text(
                            "Already have an account? Login.",
                            style: TextStyle(color: Color(0xffcfa5e4)),
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}