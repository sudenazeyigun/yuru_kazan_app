import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'location.dart';

const apiKey = "f60d74809317587b5fb0ac49380b1682";

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({required this.weatherIcon, required this.weatherImage});
}

class WeatherData {
  //WeatherData({required this.locationData});

  late LocationHelper locationData;
  late double currentTemperature;
  late int currentCondition;
  late String city;

  WeatherData(
      {required this.city,
      required this.currentCondition,
      required this.currentTemperature});

  Future<WeatherData?> getCurrentTemperature() async {
    locationData = LocationHelper();
    await locationData.getCurrentLocation();

    Response response = await get(Uri.parse(
            "http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric"))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        city = currentWeather['name'];

        return WeatherData(
            city: city,
            currentCondition: currentCondition,
            currentTemperature: currentTemperature);
      } catch (e) {
        print(e);
      }
    } else {
      print("API den değer gelmiyor!");
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      //hava bulutlu
      return WeatherDisplayData(
          weatherIcon: Icon(Icons.cloud, size: 75.0, color: Colors.white),
          weatherImage: AssetImage('assets/bulutlu.png'));
    } else {
      //hava iyi
      //gece gündüz kontrolü
      var now = new DateTime.now();
      if (now.hour >= 19) {
        return WeatherDisplayData(
            weatherIcon: Icon(Icons.nightlife, size: 75.0, color: Colors.white),
            weatherImage: AssetImage('assets/gece.png'));
      } else {
        return WeatherDisplayData(
            weatherIcon: Icon(Icons.sunny),
            weatherImage: AssetImage('assets/gunesli.png'));
      }
    }
  }
}
