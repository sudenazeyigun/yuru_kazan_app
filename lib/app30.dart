import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Maps extends StatefulWidget {
  double latitude, longitude;

  // ignore: use_key_in_widget_constructors
  Maps({required this.latitude, required this.longitude});

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Set<Polyline> polyline = {};

  String google_api_key = "AIzaSyDRXFXG3TkkP2It1Kf2TCSl6KTPutNzbWM";
  GoogleMapController? _controller;

  static const LatLng sourceLocation = LatLng(39.8927, 32.8152);
  static const LatLng destination = LatLng(39.8890, 32.8161);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then((location2) {
      currentLocation = location2;
    });

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      setState(() {});
    });
  }

  void getPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolylines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarih gelecek',
        ),
      ) ,
      body:Container(
         color :Color.fromARGB(57, 3, 168, 244),
        child: Column(
          
          children: [
            Container(//Map's ConTainer
            padding: EdgeInsets.only(bottom:8),
              height: _size.height /2,
              width: _size.width,
              decoration: BoxDecoration(
                        
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:LatLng(39,34) ,
                  zoom: 5
                ),
              ),
              ),
            
            Container(//Details Container
            
            
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: _size.width/22,),
                      Container(//Toplam Mesafe
                     
                      height: _size.height/4,
                      width: _size.width*6/22,
                     decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 246, 245),
                          borderRadius: BorderRadius.all(
                            Radius.circular(40)
                          ),
                        )
                      ),
                      SizedBox(width: _size.width/22,),
                      Container(//ort hız
                    
                        height: _size.height/4,
                        width: _size.width*6/22,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 246, 245),
                          borderRadius: BorderRadius.all(
                            Radius.circular(40)
                          ),
                        )
                      ),
                      SizedBox(width: _size.width/22,),
                      Container(
                       
                        height: _size.height/4,
                        width: _size.width*6/22,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 246, 245),
                          borderRadius: BorderRadius.all(
                            Radius.circular(40)
                          ),
                        )
                       
                      ),
                      SizedBox(width: _size.width/22,),
                    ],
                  ),
              ]),
            ),
            SizedBox(height: 10,),
            Container(//Button Container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  ElevatedButton(
                    onPressed: () {
                    
                    }, 
                    child: const Text(
                      'BAŞLAT',
                      ),
                  ),
                  SizedBox(width: _size.width/2,),
                  ElevatedButton(
                    onPressed: () {
                    
                    }, 
                    child: const Text(
                      'BİTİR',
                    ),
                  )
                ],  
              ),
            )
          ],
        ),
      )  
    );
  }
}