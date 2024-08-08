import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faztapp/dto/user/register_user_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailPassword(
      RegisterUserDto userDto) async {
    try {
      // create user in auth module from Firebase
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userDto.email, password: userDto.password);

      // save user in Firestore
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uuid": userCredential.user!.uid,
        "email": userCredential.user!.email,
        "username": userDto.userName,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
