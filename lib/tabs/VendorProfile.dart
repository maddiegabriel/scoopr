import 'package:flutter/material.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:scoopr/signIn.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorProfileTab extends StatefulWidget{
  @override
  _VendorProfileTabState createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> with TickerProviderStateMixin{
  String _businessName = "";
  String _license = "";

  _VendorProfileTabState() {
    getBname().then((val) => setState(() {
      _businessName = val;
    }));
    getLicense().then((val) => setState(() {
      _license = val;
    }));
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool editing = false;

  bool isEditing() {
    return editing;
  }

  setIsEditing(state) {
    editing = state;
  }

  getButtonText() {
    if(editing) {
      return "SAVE CHANGES";
    } else {
      return "EDIT PROFILE";
    }
  }

  String getDisplayName() {
    User currUser = FirebaseAuth.instance.currentUser;
    print(currUser);
    print('inside getDisplayName');
    if (currUser != null) {
      return currUser.displayName;
    } else {
      return "Your Name";
    }
  }

  String getEmail() {
    User currUser = FirebaseAuth.instance.currentUser;
    print('inside getEmail');
    if (currUser != null) {
      return currUser.email;
    } else {
      return "Email";
    }
  }

  Future<String> getBname() async {
    // get users collection from firebase
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // get uid of currently authenticated user
    String uid = FirebaseAuth.instance.currentUser.uid.toString();

    // get the document in 'Users' whose id matches the uid we just got
    DocumentSnapshot user = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    // get any field from the document
    String type = user.get('businessName');

    return type;
  }

  Future<String> getLicense() async {
    // get users collection from firebase
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // get uid of currently authenticated user
    String uid = FirebaseAuth.instance.currentUser.uid.toString();

    // get the document in 'Users' whose id matches the uid we just got
    DocumentSnapshot user = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

    // get any field from the document
    String type = user.get('license');

    return type;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Hey, " + getDisplayName() + "!", style: TextStyle(
            color: Colors.black
           )),
           backgroundColor: Colors.white,
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              new Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 10.0, left: 20.0),
                        child: Text(
                          "YOUR PROFILE",
                          style: TextStyle(
                              color: Color(0xff7bc1e4),
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 10.0),
                        child: TextField(
                            controller: nameController,
                            enabled: isEditing(),
                            decoration: InputDecoration(
                                hintText: getDisplayName(),
                                labelText: "Name",
                                floatingLabelBehavior: FloatingLabelBehavior.always
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 10.0),
                        child: TextField(
                          controller: emailController,
                          enabled: isEditing(),
                          decoration: InputDecoration(
                              hintText: getEmail(),
                              labelText: "Email",
                              floatingLabelBehavior: FloatingLabelBehavior.always
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 10.0),
                        child: TextField(
                          controller: businessController,
                          enabled: isEditing(),
                          decoration: InputDecoration(
                              hintText: _businessName,
                              labelText: "Business Name",
                              floatingLabelBehavior: FloatingLabelBehavior.always
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 0, right: 20.0, bottom: 10.0),
                        child: TextField(
                          controller: licenseController,
                          enabled: isEditing(),
                          decoration: InputDecoration(
                              hintText: _license,
                              labelText: "Vendor License",
                              floatingLabelBehavior: FloatingLabelBehavior.always
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: 180, height: 60),
                          child:
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff9CB6E4),
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              onPressed: () {
                                if(!isEditing()) {
                                  setIsEditing(true);
                                  setState(() {});
                                } else {
                                  // get new info
                                  String newName = getDisplayName();
                                  String newEmail = getEmail();
                                  String newBname = _businessName;
                                  String newLicense = _license;
                                  if(nameController.text.trim() != '') {
                                    newName = nameController.text.trim();
                                  }
                                  if(emailController.text.trim() != '') {
                                    newEmail = emailController.text.trim();
                                  }
                                  if(businessController.text.trim() != '') {
                                    newBname = businessController.text.trim();
                                  }
                                  if(licenseController.text.trim() != '') {
                                    newLicense = licenseController.text.trim();
                                  }
                                  // save new info to DB
                                  final status = context.read<AuthenticationService>().editProfileVendor(newName, newEmail, newBname, newLicense);
                                  status.then((stat) {
                                    if(stat != null) {
                                      if (stat.contains("SUCCESS")) {
                                        print("UPDATE SUCCESS");
                                        setIsEditing(false);
                                        setState(() {});
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'SCOOPTASTIC!',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                content: Text('Your profile info was updated.'),
                                              );
                                            }
                                        );
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'scOOPS! Your profile could not be updated.',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                content: Text(stat),
                                              );
                                            }
                                        );
                                      }
                                    }
                                  });

                                }

                              }, child: Text(getButtonText())
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: 350, height: 80),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff9DA6F4),
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              onPressed: (){
                                context.read<AuthenticationService>().signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignInPage()),
                                );
                              }, child: Text("LOG OUT")
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}