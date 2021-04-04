import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoopr/signIn.dart';
import 'package:scoopr/authenticationService.dart';
import 'package:scoopr/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoopr/vendorHome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      String uid = FirebaseAuth.instance.currentUser.uid.toString();

      users.doc(uid).get().then((user) {
        if(user.data() != null) {
          print('@ home, document user is...');
          print(user.data()['type']);
          if (user.data()['type'] == "VENDOR") {
            return HomePage();
          } else {
            return HomePage();
          }
        }
      });
    }
    return SignInPage();
  }
}
