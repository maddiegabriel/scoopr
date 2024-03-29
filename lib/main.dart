import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/signIn.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:scoopr/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoopr/vendorHome.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: const FirebaseOptions(
      appId: '1:19638138825:android:c8484e61a698a369eb5a18',
      apiKey: 'AIzaSyCILNFb1ccVbAo2222O0r8DDydZvLpluwA',
      messagingSenderId: '19638138825',
      projectId: 'scoopr-9ccc3',
      databaseURL: 'https://scoopr-9ccc3-default-rtdb.firebaseio.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
        create: (_) => AuthenticationService(FirebaseAuth.instance)
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges
        )
      ],
      child: MaterialApp(
        title: 'Scoopr',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

Future<String> getType() async {
  // get users collection from firebase
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // get uid of currently authenticated user
  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  // get the document in 'Users' whose id matches the uid we just got
  DocumentSnapshot user = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

  // get any field from the document
  String type = user.get('type');

  return type;
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print('@ home, auth user is...');
    print(firebaseUser);

    if(firebaseUser != null) {
      return FutureBuilder<String>(
          future: getType(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data == 'VENDOR'){
                return VendorHomePage();
              } else if (snapshot.data == 'CUSTOMER'){
                return HomePage();
              } else {
                return SignInPage();
              }
            } else {
              return CircularProgressIndicator();
            }
          });
    }
    return SignInPage();
  }
}
