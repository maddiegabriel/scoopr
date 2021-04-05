import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/registerAs.dart';
import 'package:scoopr/authExceptionHandler.dart';
import 'package:scoopr/home.dart';
import 'package:scoopr/vendorHome.dart';

class SignInPage extends StatelessWidget{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  changeRoute(context, type) async {
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
      if(type == "VENDOR") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorHomePage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        // Moves text field above keyboard
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 110.0, bottom: 30.0),
                  child: Image(
                    image: new AssetImage('assets/images/logo.png'),
                    width: 260.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email"
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 30.0),
                    child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                      ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                    child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 200, height: 60),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff9CB6E4),
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                          ),
                          onPressed: (){
                              final status = context.read<AuthenticationService>().signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()
                              );
                              status.then((stat) {
                                if(stat != null) {
                                  if (stat.contains("SUCCESS")) {
                                      print("LOGIN SUCCESS");
                                      if(stat.contains("CUSTOMER")) {
                                        changeRoute(context, "CUSTOMER");
                                      } else {
                                        changeRoute(context, "VENDOR");
                                      }
                                  } else {
                                    print('LOGIN FAILURE');
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'scOOPS! Your login failed.',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            content: Text(stat),
                                          );
                                        }
                                    );
                                  }
                                }

                              });
                          },
                          child: Text("LOG IN"),
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
                      MaterialPageRoute(builder: (context) => RegisterAsPage()),
                    );
                  },
                  child: Text(
                      "Need an account? Register.",
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