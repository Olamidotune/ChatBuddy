// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:message_buddy/helper/helper_functions.dart';
import 'package:message_buddy/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
// login'


  Future signInUserWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        
        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e as String);
      return e.message;
    }
  }



// register
  Future registerUserWithEmailandPassword(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call firebase to update the user data.
        await DataBaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e as String);
      return e.message;
    }
  }

//sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF('');
      await HelperFunctions.saveUserNameSF('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
