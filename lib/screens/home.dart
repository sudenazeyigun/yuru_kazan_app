// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:yuru_kazan_app/map/activity.dart';
import 'package:yuru_kazan_app/screens/email_login.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuru_kazan_app/screens/main_screen.dart';
import 'package:yuru_kazan_app/screens/sign_in_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yuru_kazan_app/services/weather.dart';

import '../map/order_traking_page.dart';

class Home extends StatefulWidget {
  WeatherData? weatherData;

  Home({Key? key, required this.user, this.weatherData}) : super(key: key);
  User user;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(38.963745, 35.243322), zoom: 5);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController(initialPage: 0);

  GooglePolyline googlePolyline = GooglePolyline();

  int pageChanged = 0;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  var gelenEmail = "";

  var gelenMesafe = "";

  var db = FirebaseFirestore.instance;

  late GoogleMapController googleMapController;

  double total = 0.0;
  late double totalKm;
  double totalSecond = 0.0;
  double totalMinute = 0.0;
  double totalHour = 0.0;
  double totalTime = 0.0;

  Set<Polyline> _polyLines = Set<Polyline>();

  late PolylinePoints polylinePoints;

  double getTotalDistance() {
    db.collection("Activity").get().then((querySnapshot) {
      for (int i = 0; i <querySnapshot.size; i++) {
        total = total + querySnapshot.docs[i].get("distance");
      }
    });
    return total;
  }

  double getTotalTime() {
    db.collection("Time").get().then((querySnapshot) {
      for (int i = 0; i < querySnapshot.size; i++) {
        totalSecond = totalSecond + querySnapshot.docs[i].get("second");
      }
      for (int j = 0; j < querySnapshot.size; j++) {
        totalMinute = totalMinute + querySnapshot.docs[j].get("minute");
      }
      for (int k = 0; k < querySnapshot.size; k++) {
        totalHour = totalHour + querySnapshot.docs[k].get("hour");
      }
    });
    inspect(totalSecond);
    inspect(totalMinute);
    inspect(totalHour);

    totalTime = (totalHour + totalMinute / 60 + totalSecond / 3600);
    
    return totalTime;
  }

  @override
  void initState() {
    super.initState();
    getTotalDistance();
    getTotalTime();
  }

  @override
  Widget build(BuildContext context) {
    var veriler = db
        .collection('Activity')
        .where('email', isEqualTo: auth.currentUser!.email)
        .get();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: FutureBuilder<WeatherData?>(
          future:
              WeatherData(city: "", currentCondition: 0, currentTemperature: 0)
                  .getCurrentTemperature(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PageView(
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
                            height: 20,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20))),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInCubic);
                            },
                            child: Text("Geçmiş Aktivitelerim",
                                style: (TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 19))),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/gradient.png')),
                            ),
                            height: 200,
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    '${snapshot.data!.currentTemperature} °',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Text(
                                    snapshot.data!.city,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 37,
                              ),
                              Container(
                                width: 150,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.grey),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit_road),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Toplam Mesafe"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(total.toString() + " " + "m"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 150,
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.grey),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.timer_sharp),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Toplam Süre"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(totalTime.toString()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                            height: 100,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                              ),
                              Icon(
                                Icons.directions_walk,
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              Icon(
                                Icons.date_range,
                              ),
                              SizedBox(
                                width: 70,
                              ),
                              Icon(
                                Icons.timer,
                              ),
                            ],
                          ),
                          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            future: veriler,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> veri =
                                        snapshot.data!.docs[index].data();
                                    double totalDistance;
                                    getTotalDistance() {
                                      double total = 0.0;
                                      for (int i = 0;
                                          i <
                                              snapshot.data!.docs[index]
                                                  .data()
                                                  .length;
                                          i++) {
                                        total = total + veri["distance"];
                                        return total;
                                      }
                                    }

                                    return Center(
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: SizedBox(
                                          width: 330,
                                          height: 50,
                                          child: Center(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Activity(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                  veri['distance'].toString() +
                                                      "  metre " +
                                                      "    " +
                                                      veri['date'].toString() +
                                                      "    " +
                                                      veri["time"].toString()),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
