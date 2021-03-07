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
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password, String name}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: name);
      userSetup(name);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> userSetup(String displayName) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    users.add({'displayName': displayName, 'uid': uid});
    return;
  }

  Future<String> vendorSignUp({String email, String password, String name, String business, String license}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: name);
      vendorUserSetup(name, business, license);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> vendorUserSetup(String displayName, String businessName, String license) async {
    CollectionReference users = FirebaseFirestore.instance.collection('VendorUsers');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    users.add({'displayName': displayName, 'uid': uid, 'businessName': businessName, 'license': license});
    return;
  }
}