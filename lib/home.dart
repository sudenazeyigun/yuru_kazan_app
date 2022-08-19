// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuru_kazan_app/app30.dart';
import 'package:yuru_kazan_app/email_login.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuru_kazan_app/sign_in_page.dart';

import 'components/order_traking_page.dart';

class Home extends StatelessWidget {
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Home({Key? key, required this.user}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;

  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState() {
            pageChanged = index;
          }
        },
        children: [
          Container(
            color: Colors.white10,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${_auth.currentUser!.email}",
                  textAlign: TextAlign.center,
                  style: (TextStyle(fontSize: 15)),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GooglePolylines()));
                  },
                  child: Text("Yeni Aktivite Başlat",
                      style: (TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20))),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    pageController.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInCubic);
                  },
                  child: Text("Geçmiş Aktivitelerim",
                      style: (TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 19))),
                ),
                SizedBox(
                  height: 380,
                ),
               ElevatedButton.icon(
                      onPressed: (){
                        
                      }, 
                      icon: Icon(Icons.logout),  
                      label:  Text("Çıkış Yap", style: (TextStyle(fontSize: 20)),), 
                      style: ElevatedButton.styleFrom(
                         primary: Colors.blueAccent 
                      ),)
              ],
            ),
          ),
          Container(
            color: Colors.white10,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.location_on,
                  size: 60,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Geçmiş Aktivitelerim",
                  style: (TextStyle(fontSize: 15)),
                ),
                SizedBox(
                  height: 500,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: FloatingActionButton(
                        onPressed: () {
                          pageController.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInCubic);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.white,
                          size: 20,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
