import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.blue,
        ),
        body: Center(
            child: Column(
                children: <Widget>[
                  new Image(
                    image: new AssetImage('assets/images/logo.jpg'),
                    height: 150.0,
                    width: 300.0,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "Name"
                    ),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email"
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: "Password"
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                          context.read<AuthenticationService>().signUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              name: nameController.text.trim()
                          );
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text("Sign Up")
                  )
                ]
            )
        )
    );
  }
}