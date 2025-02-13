import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapVisualizer {
  Widget displayMap(String latitude, String longitude) {
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
}
