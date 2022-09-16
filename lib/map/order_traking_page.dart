import 'dart:async';
// ignore_for_file: prefer_const_constructors
import 'package:email_auth/email_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:yuru_kazan_app/model/user_model.dart';
import 'package:yuru_kazan_app/screens/email_register.dart';
import 'package:yuru_kazan_app/screens/home.dart';
import 'package:yuru_kazan_app/services/location_services.dart';

late final User user2;

class GooglePolylines extends StatefulWidget {
  const GooglePolylines({Key? key}) : super(key: key);
  @override
  GooglePolyline createState() => GooglePolyline();
}

class GooglePolyline extends State<GooglePolylines> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;

  void stopTimer() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;
      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";
      started = false;
    });
  }

  void startTimer() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }

      setState(() {
        getTotalDistance();
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  String getTime() {
    String time = "$digitHours:$digitMinutes:$digitSeconds";
    return time;

  }

  EmailPasswordRegisterPage emailPasswordRegisterPage =
      EmailPasswordRegisterPage();
  late GoogleMapController googleMapController;
  late double _originLatitude, _originLongitude;
  late double _destLatitude = currentLocation.latitude!,
      _destLongitude = currentLocation.longitude!;
  Set<Polyline> _polyLines = {};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> _newPolylines = [];
  late PolylinePoints polylinePoints;
  late LocationData currentLocation;
  late LocationData destinationLocation;
  late Future<Position> position;
  late Location location;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late double _currentLatitude = currentLocation.latitude!;
  late double _currentLongitude = currentLocation.longitude!;
  late StreamSubscription<LocationData> subscription;
  UserModel _userModel = UserModel();
  List<GeoPoint> coordinates = [];
  String googleAPiKey = "AIzaSyDN63qst3lpQ6S65Q7z2vSXAX88isaqAHU";
  List<GeoPoint> locations = [];
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(38.963745, 35.243322), zoom: 5);
  final Set<Marker> markers = {};
  List<double> totalDistance = [];

  void getCurrentLocation() {
    location = Location();
    LatLng lastPoint = LatLng(30, 30);

    Geolocator.getPositionStream().listen((clocation) {
      currentLocation = LocationData.fromMap(
          {"latitude": clocation.latitude, "longitude": clocation.longitude});
      currentMarker(currentLocation);
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(clocation.latitude, clocation.longitude),
              zoom: 16),
        ),
      );

      if (Geolocator.distanceBetween(clocation.latitude, clocation.longitude,
              lastPoint.latitude, lastPoint.longitude) >
          25) {
        locations.add(GeoPoint(clocation.latitude, clocation.longitude));
        _newPolylines.add(LatLng(clocation.latitude, clocation.longitude));
        lastPoint = LatLng(clocation.latitude, clocation.longitude);
        setPolyLines();
      }
    });
  }

  void currentMarker(LocationData location) {
    markers.add(Marker(
        markerId: const MarkerId('current'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(location.latitude!, location.longitude!)));
    setState(() {});
  }

  static get locationSettings => null;
  @override
  void initState() {
    getTotalDistance();
    super.initState();
    getCurrentLocation();
    polylinePoints = PolylinePoints();

    for (int i = 0; i < polylineCoordinates.length; i++) {
      markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: polylineCoordinates[i],
        icon: BitmapDescriptor.defaultMarker,
      ));

      setState(() {});
    }

    _polyLines.add(
        Polyline(polylineId: PolylineId("1"), points: polylineCoordinates));
  }

  @override
  Widget build(BuildContext context) {
    GeoLocations geoLocations = GeoLocations();
    late double distanceInMeters;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 650,
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              polylines: _polyLines,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(120.0, 15.0, 120.0, 20.0),
            child: Text(
              "$digitHours:$digitMinutes:$digitSeconds",
              style: (TextStyle(fontSize: 20)),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.fromLTRB(120.0, 15.0, 120.0, 60.0),
            child: Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  getDate();

                  aktiviteEkle(String email, double distance, String date) {
                    FirebaseFirestore.instance
                        .collection("Activity")
                        .doc()
                        .set({
                      "email": _auth.currentUser?.email,
                      "distance": distanceInMeters.toInt(),
                      "date": getDate().toString(),
                      "time": getTime(),
                      "coordinates": locations,
                    });
                  }

                   zamanEkle(int seconds, int minutes,
                      int hours) {
                    FirebaseFirestore.instance.collection("Time").doc().set({
                      "second": double.parse(digitSeconds),
                      "minute": double.parse(digitMinutes),
                      "hour": double.parse(digitHours)
                    });
                  }

                  distanceInMeters = Geolocator.distanceBetween(_originLatitude,
                      _originLongitude, _destLatitude, _destLongitude);
                  double distance = distanceInMeters;
                  totalDistance.add(distance);
                  debugPrint("#######################");

                  debugPrint(totalDistance.toString());
                  debugPrint("#######################");

                  Fluttertoast.showToast(
                      msg: (distanceInMeters.toString()) + " metre yürüdünüz!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  aktiviteEkle(_auth.currentUser!.email!, distanceInMeters,
                      getDate().toString());
                  zamanEkle(seconds, minutes, hours);
                },
                child: Text(
                  "Hesapla",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.white, fontStyle: FontStyle.normal),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 90,
        height: 90,
        padding: const EdgeInsets.only(bottom: 30),
        child: SpeedDial(
          backgroundColor: Colors.black,
          animatedIcon: AnimatedIcons.menu_arrow,
          children: [
            SpeedDialChild(
                child: Icon(Icons.location_on),
                label: "Başla",
                onTap: () async {
                  (!started) ? startTimer() : stopTimer();
                  markers.clear();

                  markers.add(Marker(
                      markerId: const MarkerId('source'),
                      position: LatLng(currentLocation.latitude!,
                          currentLocation.longitude!)));
                  markers.add(Marker(
                      markerId: const MarkerId('current'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      position: LatLng(currentLocation.latitude!,
                          currentLocation.longitude!)));

                  _originLatitude = currentLocation.latitude!;
                  _originLongitude = currentLocation.longitude!;

                  setState(() {});
                }),
            SpeedDialChild(
                child: Icon(Icons.location_off),
                label: "Bitir",
                onTap: () {
                  stopTimer();
                  debugPrint("####################");

                  String time = getTime();
                  debugPrint(time);
                  setState(() {
                    markers.add(Marker(
                        markerId: const MarkerId('destination'),
                        position: LatLng(currentLocation.latitude!,
                            currentLocation.longitude!)));
                    markers.removeWhere(((Marker marker) =>
                        marker.markerId == MarkerId("current")));
                    _destLatitude = currentLocation.latitude!;
                    _destLongitude = currentLocation.longitude!;

                    setPolyLines();
                    distanceInMeters = Geolocator.distanceBetween(
                        _originLatitude,
                        _originLongitude,
                        _destLatitude,
                        _destLongitude);
                  });
                }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void setPolyLines() async {
    setState(() {
      _polyLines.add(Polyline(
          visible: true,
          width: 6,
          polylineId: PolylineId('polyLineTest'),
          color: Colors.blue,
          points: _newPolylines));
    });
  }

  getDate() {
    String myTime = DateTime.now().toUtc().toString();
    final f = new DateFormat("dd-MM-yyyy hh:mm");
    int myvalue = 1558432747;

    String newMyTime =
        f.format(new DateTime.fromMillisecondsSinceEpoch(myvalue * 1000));

    return newMyTime;
  }

  getTotalDistance() {
    double total = 0.0;
    for (int i = 0; i < totalDistance.length; i++) {
      total = totalDistance[i];
      return total;
    }
  }
}
