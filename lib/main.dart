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