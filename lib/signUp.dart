import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/registerAs.dart';

class SignUpPage extends StatelessWidget{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent,
                        ),
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
                          Navigator.pop(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterAsPage()),
                          );
                        },
                        child: Text("Sign Up")
                    )
                  ]
              )
          )
        )
    );
  }
}