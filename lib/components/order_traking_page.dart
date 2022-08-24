import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:yuru_kazan_app/services/location_services.dart';

class GooglePolylines extends StatefulWidget {
  const GooglePolylines({Key? key}) : super(key: key);
  @override
  GooglePolyline createState() => GooglePolyline();
}

class GooglePolyline extends State<GooglePolylines> {
  late GoogleMapController googleMapController;
  double _originLatitude = 39.8926595, _originLongitude = 32.8152389;
  double _destLatitude = 39.8889543, _destLongitude = 32.8156751;
  Set<Polyline> _polyLines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  late LocationData currentLocation;
  late LocationData destinationLocation;
  late Future<Position> position;
  late Location location;
  late StreamSubscription<LocationData> subscription;
  String googleAPiKey = "AIzaSyDN63qst3lpQ6S65Q7z2vSXAX88isaqAHU";
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(38.963745, 35.243322), zoom: 5);
  Set<Marker> markers = {};

  void getCurrentLocation() {
    location = Location();
    position = Geolocator.getCurrentPosition();

    location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;
      locatio(currentLocation);
    });

    location.onLocationChanged.listen((l) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 16),
        ),
      );
    });
  }

  void locatio(LocationData location) {
    markers.add(Marker(
        markerId: const MarkerId('current'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(location.latitude!, location.longitude!)));

    setState(() {
      getCurrentLocation();
    });
  }

  static get locationSettings => null;
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    polylinePoints = PolylinePoints();
  }

  @override
  @override
  Widget build(BuildContext context) {
    GeoLocations carcurt = GeoLocations();
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;

              setPolyLines();
            },
            polylines: _polyLines,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: SpeedDial(
          backgroundColor: Colors.black,
          animatedIcon: AnimatedIcons.menu_arrow,
          children: [
            SpeedDialChild(
                child: Icon(Icons.location_on),
                label: "Başla",
                onTap: () async {
                  // Position? position = await Geolocator.getCurrentPosition();

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
                  markers.add(Marker(
                      markerId: const MarkerId('destination'),
                      position: LatLng(39.8890, 32.8157)));

                  setState(() {});
                }),
            SpeedDialChild(
                child: Icon(Icons.location_off), label: "Bitir", onTap: () {

                  
                })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    ));
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

  StreamSubscription<Position> positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) {
    print(position == null
        ? 'Unknown'
        : '${position.latitude.toString()}, ${position.longitude.toString()}');
  });

  void setPolyLines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.walking,
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polyLines.add(Polyline(
            visible: true,
            width: 6,
            polylineId: PolylineId('polyLineTest'),
            color: Colors.blue,
            points: polylineCoordinates));
      });
    }
  }
}
