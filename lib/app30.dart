import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController? controller;

  final CameraPosition initialPosition =
      const CameraPosition(target: LatLng(39.8866325, 32.7671915), zoom: 14);
  var typemap = MapType.normal;
  var cordinate1 = 'cordinate';
  var lat = 39.8866325;
  var long = 32.7671915;

  var address = '';
  var options = [
    MapType.normal,
  ];
  Future<void> getAddress(latt, longg) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latt, longg);
    print(
        '-----------------------------------------------------------------------------------------');
    print(placemark);
    print(
        '-----------------------------------------------------------------------------------------');
    Placemark place = placemark[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              const Marker(
                markerId: MarkerId('asdasd'),
                position: LatLng(39.8866325, 32.7671915),
              ),
            },
            initialCameraPosition: initialPosition,
            mapType: typemap,
            onMapCreated: (controller) {
              setState(() {
                controller = controller;
              });
            },
            onTap: (cordinate) {
              setState(() {
                lat = cordinate.latitude;
                long = cordinate.longitude;
                getAddress(lat, long);

                cordinate1 = cordinate.toString();
              });
            },
          ),
          Positioned(
            left: 5,
            bottom: 150,
            child: Text(
              cordinate1,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Positioned(
            left: 15,
            bottom: 100,
            child: Container(
              width: 200,
              child: Text(
                address,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
