import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_twitter_app/models/user_model.dart';
import 'package:simple_twitter_app/utils/dialogs.dart';
import 'package:simple_twitter_app/utils/strings.dart';
import 'package:simple_twitter_app/utils/toast.dart';

class AuthService{
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    return user != null ? UserModel(id: user.uid) : null;
  }

  Stream<UserModel?> get user {
    return auth.authStateChanges().map(_userFromFirebase);
  }

  UserModel? get initilaUser{
    auth.authStateChanges().map(_userFromFirebase).single.then((value) {
      return value;
    }).catchError((onError){
      return null;
    });
  }

  Future<bool> signUp(BuildContext context,String email,String password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user?.uid)
          .set({'name': email, 'email': email,"profileImageUrl":"", "bannerImageUrl":""});

      _userFromFirebase(user.user);
      showToast(STRINGS.successful);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast(STRINGS.password_too_weak);
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        showToast(STRINGS.email_already_exist);
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }else{
        print('Firebase Auth ERROR >> '+e.toString());
        showToast(e.toString());
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showToast(STRINGS.something_went_wrong);
      return false;
    }
  }

  Future<bool> signIn(BuildContext context,String email,String password) async {

    try {
      // User user = (await auth.signInWithEmailAndPassword(
      //     email: email, password: password)) as User;

      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      hideDialog(context);
      _userFromFirebase(user.user);
      showToast(STRINGS.successful);
      if (kDebugMode) {
        print(STRINGS.successful);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showToast(STRINGS.something_went_wrong);
      hideDialog(context);
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showToast(STRINGS.something_went_wrong);
      hideDialog(context);
      return false;
    }
  }

  Future signOut() async {
    try{
      return await auth.signOut();
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}