import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/registerAs.dart';
import 'package:scoopr/SignIn.dart';
import 'package:scoopr/home.dart';

class VendorSignUpPage extends StatelessWidget{
  final TextEditingController nameController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                        "Vendor Sign Up",
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
                              )
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
                          controller: businessController,
                          decoration: InputDecoration(
                              labelText: "Business Name"
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 10.0),
                        child: TextField(
                          controller: licenseController,
                          decoration: InputDecoration(
                              labelText: "Vendor License Number"
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
                                  final status = context.read<AuthenticationService>().vendorSignUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      name: nameController.text.trim(),
                                      business: businessController.text.trim(),
                                      license: licenseController.text.trim()
                                  );
                                  status.then((stat) {
                                    print("WELCOME TO THE FUTURE!!!!");
                                    print(stat);
                                    if (stat == "SUCCESS") {
                                      // Navigate to success screen
                                      print("CUSTOMER SIGN UP SUCCESS");
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(builder: (context) => VendorSignUpPage()),
                                      );
                                      Navigator.pop(
                                        context,
                                        MaterialPageRoute(builder: (context) => RegisterAsPage()),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomePage()),
                                      );
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