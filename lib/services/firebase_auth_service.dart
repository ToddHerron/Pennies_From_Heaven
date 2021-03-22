import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:pennies_from_heaven/models/user.dart';

@immutable
class FirebaseAuthService {
  final _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  // Sign in Anonymously

  // TODO Create more graceful error handling

  // Future<User?> signInAnonymously() async {
  //   try {
  //     auth.UserCredential userCredential =
  //         await _firebaseAuth.signInAnonymously();
  //     return _userFromFirebase(userCredential.user);
  //   } catch (e) {
  //     print('🟥 🟥 🟥 Error ' + e.toString());
  //     return null;
  //   }
  // }

  // Register with email and password

  Future<User?> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print('🟥 🟥 🟥 Error ' + e.toString());
      return null;
    }
  }

  // Sign in with email and password

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      print('🟥 🟥 🟥 Error ' + e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
