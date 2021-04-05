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

      // await FirebaseFirestore.instance.collection('Users').where(
      //     FieldPath.documentId,
      //     isEqualTo: uid
      // ).getDocuments().then((event) {
      //   if (event.documents.isNotEmpty) {
      //     Map<String, dynamic> documentData = event.documents.single.data; //if it is a single document
      //   }
      // }).catchError((e) => print("error fetching data: $e"));
      //

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
      print('HEY ' + name);
      User updateUser = FirebaseAuth.instance.currentUser;
      updateUser.updateProfile(displayName: name);
      userSetup(name);
      return "CUSTOMER SUCCESS";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> userSetup(String displayName) async {
    print('HEY2 ' + displayName);
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
}
