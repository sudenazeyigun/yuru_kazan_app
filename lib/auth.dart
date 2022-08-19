import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  void inputData() {
    final User? user = _auth.currentUser;
    final uid = user?.uid;

    // here you write the codes to input the data into firestore
  }
  

//Giriş yap fonk
  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

//Çıkış Yap Fonk

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //Kayıt Ol Fonk

  Future<User?> createPerson(
      String ad, String soyad, String email, String password) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firestore.collection("Person").doc(user.user?.uid).set(
          {"name": ad, "surname": soyad, "email": email, "password": password});
      return user.user;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
