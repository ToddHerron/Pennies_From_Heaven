import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:pennies_from_heaven/models/user.dart';
import 'package:get_it/get_it.dart';
import 'package:pennies_from_heaven/models/register_auth_error.dart';
import 'package:pennies_from_heaven/models/sign_in_auth_error.dart';

@immutable
class FirebaseAuthService {
  final _firebaseAuth = auth.FirebaseAuth.instance;

  User? _userFromFirebase(auth.User? user) {
    return user == null ? null : User(uid: user.uid);
  }

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  // Register with email and password

  Future<User?> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    GetIt.I<RegisterAuthError>().setRegisterAuthError("");
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      GetIt.I<RegisterAuthError>().setRegisterAuthError(e.message!);
      return null;
    }
  }

  // Sign in with email and password

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    GetIt.I<SignInAuthError>().setSignInAuthError("");
    try {
      auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      GetIt.I<SignInAuthError>().setSignInAuthError(e.message!);
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
