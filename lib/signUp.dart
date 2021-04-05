import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/registerAs.dart';
import 'package:scoopr/SignIn.dart';
import 'package:scoopr/home.dart';

class SignUpPage extends StatelessWidget{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  changeRoute(context) async {
    await Future.delayed(Duration(seconds: 1), () {

      // Navigator.pop(
      //   context,
      //   MaterialPageRoute(builder: (context) => SignUpPage()),
      // );
      // Navigator.pop(
      //   context,
      //   MaterialPageRoute(builder: (context) => RegisterAsPage()),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
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
                      padding: const EdgeInsets.only(top: 70.0, bottom: 40.0),
                      child: Image(
                        image: new AssetImage('assets/images/logo.png'),
                        width: 260.0,
                      ),
                    ),
                    Text(
                      "Customer Sign Up",
                      style: TextStyle(
                          color: Color(0xff7bc1e4),
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 10.0),
                        child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                labelText: "Name"
                            ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 10.0),
                        child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  labelText: "Email"
                              ),
                            ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 10.0),
                        child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  labelText: "Password"
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 30.0),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            labelText: "Confirm Password"
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
                                onPressed: () {
                                  if(passwordController.text != confirmPasswordController.text) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              'scOOPS! Your sign up failed.',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            content: Text('Your passwords don\'t match - please try again!'),
                                          );
                                        }
                                    );
                                  } else {
                                    final status = context.read<AuthenticationService>().signUp(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                        name: nameController.text.trim(),
                                        type: 'CUSTOMER'
                                    );
                                    status.then((stat) {
                                      print(stat);
                                      if (stat.contains("SUCCESS")) {
                                        // Navigate to success screen
                                        print("CUSTOMER SIGN UP SUCCESS");
                                        changeRoute(context);
                                      } else {
                                        print('CUSTOMER SIGN UP FAILURE');
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'scOOPS! Your sign up failed.',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                content: Text(stat),
                                              );
                                            }
                                        );
                                      }
                                    });
                                  }
                                },
                                child: Text("SIGN UP")
                            )
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
                          "Already have an account? Log In.",
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