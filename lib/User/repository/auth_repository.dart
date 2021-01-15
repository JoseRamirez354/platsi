import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzy/User/repository/firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthApi = FirebaseAuthApi();
  Future<FirebaseUser> signInFirebase() => _firebaseAuthApi.signIn();

  signOut() => _firebaseAuthApi.signOut();
}
