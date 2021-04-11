import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      String uid = FirebaseAuth.instance.currentUser.uid.toString();
      DocumentSnapshot user = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      String type = user.get('type');
      if(type == "CUSTOMER") {
        return "CUSTOMER SUCCESS";
      } else {
        return "VENDOR SUCCESS";
      }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password, String name, String type}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: name);
      userSetup(name);
      return "CUSTOMER SUCCESS";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> userSetup(String displayName) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    users.doc(uid).set({'displayName': displayName, 'uid': uid, 'type': 'CUSTOMER'});
    return;
  }

  Future<String> vendorSignUp({String email, String password, String name, String business, String license, String type}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: name);
      vendorUserSetup(name, business, license);
      return "VENDOR SUCCESS";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> vendorUserSetup(String displayName, String businessName, String license) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    users.doc(uid).set({'displayName': displayName, 'uid': uid, 'businessName': businessName, 'license': license, 'type': 'VENDOR'});
    return;
  }

  Future<String> editProfileCustomer(String displayName, String email) async {
    // update them in firestore
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid.toString();
      users.doc(uid).set({'displayName': displayName, 'email': email});

      // update them in auth DB
      var updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: displayName);
      updateUser.updateEmail(email);
      return "SUCCESS";
    } on FirebaseAuthException catch (e) {
      return "FAILURE";
    }
  }

  Future<String> editProfileVendor(String displayName, String email, String bName, String license) async {
    // update them in firestore
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser.uid.toString();
      users.doc(uid).set({'displayName': displayName, 'email': email, 'businessName': bName, 'license': license});

      // update them in auth DB
      var updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: displayName);
      updateUser.updateEmail(email);
      return "SUCCESS";
    } on FirebaseAuthException catch (e) {
      return "FAILURE";
    }
  }
}
