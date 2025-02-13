import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import './Client/client.dart';

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
  Map<String, dynamic> data = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading = true;

    ClientTracker client = ClientTracker();
    try {
      final fetchedData = await client.fetchData();
      setState(() {
        data = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        data = {'error': e.toString()};
        isLoading = false;
      });
    }
  }

  Widget _displayMap(String latitude, String longitude) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(double.parse(latitude), double.parse(longitude)),
        initialZoom: 3.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: [
            Marker(
                point: LatLng(double.parse(latitude), double.parse(longitude)),
                child: const Image(image: AssetImage('assets/iss.png'))),
          ],
        ),
      ],
    );
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
              log('http://www.openstreetmap.org/?mlat=${data['iss_position']['latitude']}&mlon=${data['iss_position']['longitude']}&zoom=3');

              return _displayMap(
                data['iss_position']['latitude'].toString(),
                data['iss_position']['longitude'].toString(),
              );
            }
          }),
        ));
  }
}
