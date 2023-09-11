import 'dart:convert';
import 'package:droidtech/apikey.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String apiKey = weatherApiKey;

  var weatherData = {};

  Future<void> getWeather(String location) async {
    if (location != '') {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&APPID=$apiKey'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          weatherData = data;
        });
      } else {
        throw Exception(
            'API request failed with status code: ${response.statusCode}');
      }
    }
  }

  final date = DateTime.now();

  TextEditingController locationController = TextEditingController();

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              margin: EdgeInsets.only(top: statusBarHeight),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration:
                    const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextField(
                              controller: locationController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(255, 255, 255, 0.6),
                                hintText: 'Enter a location',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 18),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                  height: 50, width: 150),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(99),
                                    )),
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(
                                            255, 255, 255, 0.4)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      getWeather(locationController.text);
                                      locationController.text = '';
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus(); // Hide the keyboard
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                    });
                                  },
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            weatherData.isNotEmpty
                                ? Column(
                                    children: [
                                      Text(
                                        weatherData['name'],
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        '${days[date.weekday - 1]} ${date.day}th ${months[date.month - 1]} ${date.year}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(30),
                                        decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  blurStyle: BlurStyle.outer,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.2),
                                                  spreadRadius: 1,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: Text(
                                          '${weatherData['main']['temp']}°C',
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 50,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                              'http://openweathermap.org/img/w/${weatherData['weather'][0]['icon']}.png'),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            weatherData['weather'][0]
                                                ['description'],
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : const Text(
                                    'Please provide a location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                            const SizedBox(height: 30),
                            const Text(
                              '- developed by Droid Tech',
                              style: TextStyle(
                                  fontFamily: 'Poppins', color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
