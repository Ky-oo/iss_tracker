import 'dart:async';
import 'dart:developer';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Services/Client/client.dart';
import 'Services/Map/map.dart';
import 'Services/Position/locator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

double calculateDistance(position1, position2) {
  var p = 0.017453292519943295;
  var c = Math.cos;
  var a = 0.5 -
      c((position2["latitude"] - position1["latitude"]) * p) / 2 +
      c(position1["latitude"] * p) *
          c(position2["latitude"] * p) *
          (1 - c((position2["longitude"] - position1["longitude"]) * p)) /
          2;
  var radiusOfEarth = 6371;
  return radiusOfEarth * 2 * Math.asin(Math.sqrt(a));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  Map<String, double> issPosition = {};
  Map<String, double> userPosition = {};

  @override
  void initState() {
    super.initState();
    _loadData();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _loadData());
  }

  Future<void> _loadData() async {
    isLoading = true;
    try {
      final fetchedData = await ClientTracker().fetchData();
      final Position position = await Locator().determinePosition();

      issPosition = {
        'latitude': double.parse(fetchedData['iss_position']['latitude']),
        'longitude': double.parse(fetchedData['iss_position']['longitude'])
      };
      userPosition = {
        'latitude': position.latitude,
        'longitude': position.longitude
      };
    } catch (e) {
      setState(() {
        log("error: $e");
      });
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('ISS TRACKER',
              style: GoogleFonts.quicksand(
                  fontSize: 40, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Center(
          child: Builder(builder: (context) {
            if (isLoading) {
              return CircularProgressIndicator();
            } else {
              return MapVisualizer().displayMap(issPosition, userPosition);
            }
          }),
        ));
  }
}
