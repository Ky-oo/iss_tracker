import 'dart:async';
import 'dart:developer';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  Map<String, double> issPosition = {};
  Map<String, double> userPosition = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadData();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _loadData());
  }

  Future<void> _loadData() async {
    isLoading = false;
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
