import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WeatherApp(),

  ));
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String city = "Santa Ana";
  double temperature = 0.0;
  String weatherDescription = "";
  double humidity = 0.0;
  double windSpeed = 0.0;
  bool isCelsius = true;
  TextEditingController cityController = TextEditingController();
  bool isLoading = false;

  Future<void> fetchWeather({String? newCity}) async {
    setState(() {
      isLoading = true;
    });

    final apiKey = "f0cdde6dd81f0415797ef585c5307ca1";
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${newCity ??
            city}&appid=$apiKey&units=${isCelsius ? 'metric' : 'imperial'}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          city = newCity ?? city;
          temperature = data["main"]["temp"].toDouble();
          weatherDescription = data["weather"][0]["description"];
          humidity = data["main"]["humidity"].toDouble();
          windSpeed = data["wind"]["speed"].toDouble();
          isLoading = false;
        });
        } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("City not found!")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching weather data")),
      );
    }
  }