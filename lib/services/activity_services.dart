import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getActivity() {
    @override
    Widget build(BuildContext context) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Activity").snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => ListTile(
                      title: Text(doc["email"]),
                      subtitle: Text(doc["distance"]),
                    ))
                .toList(),
          );
        }),
      );
    }
  }
}
