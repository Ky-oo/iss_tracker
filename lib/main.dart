import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Services/Client/client.dart';
import 'Services/Map/map.dart';

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
              return MapVisualizer().displayMap(
                data['iss_position']['latitude'].toString(),
                data['iss_position']['longitude'].toString(),
              );
            }
          }),
        ));
  }
}
