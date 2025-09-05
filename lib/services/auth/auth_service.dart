import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // instance of Firebase Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        // add a new document if it doesn't already exist
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
        }, SetOptions(merge: true));

        print("User signed in: ${user.uid}");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        // create a new document for the user
        await _firestore.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'username': username,
        });
      }

      print("User signed up: \\${user?.uid}");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
