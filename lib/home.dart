// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuru_kazan_app/email_login.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatelessWidget {
  const Home({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('name');

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: PageView(
        children: [
          Container(
              color: Colors.white10,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Kişisel Bilgiler " ,
                    textAlign: TextAlign.center,
                    
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  Text("${user.email}")
                ],
                

              )
              ),








          Container(
            color: Colors.teal,
            child: Center(child: Text("Geçmiş Aktiviteler Sayfası")),
          ),
        ],
      ),
    );
  }
}
