import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yuru_kazan_app/map/order_traking_page.dart';
import 'package:yuru_kazan_app/screens/home.dart';
import 'package:yuru_kazan_app/screens/main_screen.dart';
import 'package:yuru_kazan_app/services/location.dart';
import 'package:yuru_kazan_app/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late LocationHelper locationData;
  Future<void> getLocationData() async {
    locationData = LocationHelper();
    await locationData.getCurrentLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      print("Konum bilgileri gelmiyor.");
    } else {
      print("latitude: " + locationData.latitude.toString());
      print("longitude: " + locationData.longitude.toString());
    }
  }

  void getWeatherData() async {
    await getLocationData();

    // WeatherData weatherData = WeatherData();
    // await weatherData.getCurrentTemperature();

    // if (weatherData.currentTemperature == null ||
    //     weatherData.currentCondition == null) {
    //   print("API den sıcaklık veya durum bilgisi boş dönüyor.");
    // }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Home(
        user: user2,
      );
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.blue]),
        ),
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 150.0,
            duration: Duration(milliseconds: 1200),
          ),
        ),
      ),
    );
  }
}
