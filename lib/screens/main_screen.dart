import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yuru_kazan_app/services/weather.dart';

class MainScreen extends StatefulWidget {

  final WeatherData weatherData;

  MainScreen({required this.weatherData});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int temperature;
  late Icon weatherDisplayIcon;
  late String city;
  void updateDisplayInfo(WeatherData weatherData){
  setState(() {
    temperature = weatherData.currentTemperature.round();
    city = weatherData.city;
    WeatherDisplayData weatherDisplayData = weatherData.getWeatherDisplayData();
    weatherDisplayIcon = weatherDisplayData.weatherIcon;
  });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateDisplayInfo(widget.weatherData);
  }

  @override
  Widget build(BuildContext context) {

    void getImage(){
      
    }
    return Scaffold(
      body: Container(
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40,),
            Container(
              child: weatherDisplayIcon,
            ),
            SizedBox(height: 15,),
            Center(
              child: Text('$temperature°',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80.0,
                letterSpacing: -5
              ),
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: Text(city,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    letterSpacing: -5
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}