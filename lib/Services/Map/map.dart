import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapVisualizer {
  Widget displayMap(
      Map<String, double> issPosition, Map<String, double> userPosition) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter:
            LatLng(issPosition['latitude'] ?? 0, issPosition['longitude'] ?? 0),
        initialZoom: 2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(
          markers: [
            Marker(
                point: LatLng(issPosition['latitude'] ?? 0,
                    issPosition['longitude'] ?? 0),
                child: const Image(image: AssetImage('assets/iss.png'))),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
                point: LatLng(userPosition['latitude'] ?? 0,
                    userPosition['longitude'] ?? 0),
                child: const Icon(Icons.location_on, color: Colors.red)),
          ],
        ),
      ],
    );
  }
}
