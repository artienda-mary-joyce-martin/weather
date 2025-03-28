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

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  IconData getWeatherIcon(String description) {
    description = description.toLowerCase();
    if (description.contains('clear')) {
      return FontAwesomeIcons.sun;
    } else if (description.contains('cloud')) {
      return FontAwesomeIcons.cloud;
    } else if (description.contains('rain')) {
      return FontAwesomeIcons.cloudRain;
    } else if (description.contains('thunderstorm')) {
      return FontAwesomeIcons.bolt;
    } else if (description.contains('snow')) {
      return FontAwesomeIcons.snowflake;
    } else if (description.contains('mist') || description.contains('fog')) {
      return FontAwesomeIcons.smog;
    }
    return FontAwesomeIcons.questionCircle;
  }

  void openSettings() {
    cityController.text = city;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16.0,
                  right: 16.0,
                  top: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Settings", style: TextStyle(fontWeight: FontWeight.bold ),),
                  SizedBox(height: 15,),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: "Enter City",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String newCity = cityController.text.trim();
                      if (newCity.isNotEmpty) {
                        fetchWeather(newCity: newCity);
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Update City"),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Celsius"),
                      Switch(
                        value: isCelsius,
                        onChanged: (value) {
                          setState(() {
                            isCelsius = value;
                          });
                          fetchWeather();
                          Navigator.pop(context);
                        },
                      ),
                      Text("Fahrenheit"),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Adding Team Members section
                  Text(
                    "Meet Our Team",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        // Team Member 1
                        _buildTeamMember(
                          "Artienda Mary Joyce",
                          "images/joy.jpg", // Make sure to add the image in your assets folder
                        ),
                        SizedBox(height: 10),
                        // Team Member 2
                        _buildTeamMember(
                          "Bulanadi Vianney",
                          "images/vianney.jpg",
                        ),
                        SizedBox(height: 10),
                        // Team Member 3
                        _buildTeamMember(
                          "Culala Andrea",
                          "images/andrea.jpg",
                        ),
                        SizedBox(height: 10),
                        // Team Member 4
                        _buildTeamMember(
                          "Gomez Dexter",
                          "images/dexter.jpg",
                        ),
                        SizedBox(height: 10),
                        // Team Member 5
                        _buildTeamMember(
                          "Timbol Christian",
                          "images/christian.jpg",
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTeamMember(String name, String imagePath) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white,),
            onPressed: openSettings,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                city,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300,color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "${temperature.toStringAsFixed(1)}° ${isCelsius ? 'C' : 'F'}",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                    color: Colors.white,

                ),
              ),
              SizedBox(height: 10),

              Icon(
                getWeatherIcon(weatherDescription),
                size: 80,
                color: getWeatherIconColor(weatherDescription),
              ),
              SizedBox(height: 5),
              Text(
                weatherDescription,
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, color: Colors.blue),
                  SizedBox(width: 5),
                  Text(
                    "Humidity: ${humidity.toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 18, color: Colors.white),

                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.air, color: Colors.lightBlueAccent),
                  SizedBox(width: 5),
                  Text(
                    "Wind Speed: ${windSpeed.toStringAsFixed(1)} m/s",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Color getWeatherIconColor(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return Color(0xFFFFA726); // Orange Accent
      case 'few clouds':
      case 'fog':
        return Color(0xFFFBFBFB); // Orange Accent

      case 'scattered clouds':
      case 'broken clouds':
        return Color(0xFF9E9E9E); // Grey
      case 'shower rain':
      case 'rain':
        return Color(0xFF1E88E5); // Blue
      case 'thunderstorm':
        return Color(0xFF673AB7); // Deep Purple
      case 'snow':
        return Color(0xFF81D4FA); // Light Blue Accent
      case 'mist':
        return Color(0xFF009688); // Teal
      default:
        return Color(0xFF448AFF); // Blue Accent
    }
  }

}