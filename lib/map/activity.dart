import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
// ignore_for_file: prefer_const_constructors

class Activity extends StatefulWidget {
  Activity({Key? key}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
  
}


class _ActivityState extends State<Activity> {
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(38.963745, 35.243322), zoom: 5);
  late GoogleMapController googleMapController;
  Set<Polyline> _polyLines = Set<Polyline>();
  var db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Set<Marker> markers = {};
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  List<GeoPoint> coordinates = [];
  String googleAPiKey = "AIzaSyDN63qst3lpQ6S65Q7z2vSXAX88isaqAHU";
  late LocationData currentLocation;
  late double _currentLatitude = currentLocation.latitude!;
  late double _currentLongitude = currentLocation.longitude!;
  late Location location;
  late Future<Position> position;

  

  @override
  void initState() {
    super.initState();
   
    polylinePoints = PolylinePoints();
  }
  @override
  

  @override
  Widget build(BuildContext context) {
    var veriler = db.collection('Activity').where('email', isEqualTo: auth.currentUser!.email).get();
    return Scaffold(
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: veriler,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  Map<String, dynamic> veri = snapshot.data!.docs[index].data();

                  List<dynamic> coordinates = veri["coordinates"];
                  markers.add(
                    Marker(
                      markerId: MarkerId('First'),
                      position: LatLng(coordinates.first.latitude, coordinates.first.longitude),
                    ),
                  );

                  markers.add(
                    Marker(
                      markerId: MarkerId('Last'),
                      position: LatLng(coordinates.last.latitude, coordinates.last.longitude),
                    ),
                  );
                  return Column(
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
                      
                      ElevatedButton(
                        onPressed: () {
                          debugPrint("##########");
                          debugPrint("${coordinates.first.latitude}");
                          debugPrint("##########");

                          debugPrint("${coordinates.first.longitude}");
                          debugPrint("##########");

                          debugPrint("${coordinates.last.latitude}");
                          debugPrint("##########");

                          debugPrint("${coordinates.last.longitude}");

                          setState(() {
                            setPolyLines(coordinates.first.latitude, coordinates.first.longitude, coordinates.last.latitude, coordinates.last.longitude);
                          });
                        },
                        child: const Text('Çizdir'),
                      )
                    ],
                  );
                }));
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  void setPolyLines(
    double firstLatitude,
    double firstLongitude,
    double lastLatitude,
    double lastLongitude,
  ) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(firstLatitude, firstLongitude),
      PointLatLng(lastLatitude, lastLongitude),
      travelMode: TravelMode.walking,
    );
    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polyLines.add(Polyline(visible: true, width: 6, polylineId: PolylineId('polyLineTest'), color: Colors.blue, points: polylineCoordinates));
      });
    }
  }
}
