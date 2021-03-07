import 'package:flutter/material.dart';
import 'package:scoopr/SignIn.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/signUp.dart';

class SignInPage extends StatelessWidget{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.blue,
        ),
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            children: <Widget>[
              new Image(
                image: new AssetImage('assets/images/logo.jpg'),
                height: 150.0,
                width: 300.0,
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
                  onPressed: (){
                    context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()
                    );
              },
              child: Text("Sign In"),
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(
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