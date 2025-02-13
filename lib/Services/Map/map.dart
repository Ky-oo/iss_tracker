import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../main.dart';

class MapVisualizer {
  Widget displayMap(
      Map<String, double> issPosition, Map<String, double> userPosition) {
    return Stack(
      children: [
        FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            initialCenter: LatLng(
                issPosition['latitude'] ?? 0, issPosition['longitude'] ?? 0),
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
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Distance: ${calculateDistance(issPosition, userPosition).toStringAsFixed(2)} km',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
