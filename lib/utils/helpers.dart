import 'dart:math';

import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<File> createFile(String name, String content) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$name');
  file.writeAsStringSync(content);

  return file;
}

Future<File> createImage(String name, String imagePath) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$name');

  final imageData = await rootBundle.load(imagePath);
  final bytes = imageData.buffer
      .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);

  file.writeAsBytesSync(bytes);

  return file;
}

List<LatLng> createCirclePolygon(LatLng center, double radiusKm,
    {int numPoints = 100}) {
  final Distance distance = Distance();
  List<LatLng> points = [];

  for (int i = 0; i < numPoints; i++) {
    double angle = i * (360 / numPoints);
    LatLng point = distance.offset(center, radiusKm * 1000, angle);
    points.add(point);
  }

  // Close the polygon by appending the first point at the end
  points.add(points[0]);

  return points;
}

double areaToRadius(double areaKm2) {
  return sqrt(areaKm2 / pi);
}

String getBoundingBox(double latitude, double longitude, double areaKm2) {
  double radiusKm = areaToRadius(areaKm2);

  // Convert radius in km to degrees of latitude (1 degree latitude is approx 111.32 km)
  double latOffset = radiusKm / 111.32;

  double minLat = latitude - latOffset;
  double maxLat = latitude + latOffset;

  double lonOffset = radiusKm / (111.32 * cos(latitude * pi / 180));

  double minLon = longitude - lonOffset;
  double maxLon = longitude + lonOffset;

  return "$minLat, $minLon, $maxLat, $maxLon";
}

String formatDateTime(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4, '0')}"
         "${dateTime.month.toString().padLeft(2, '0')}"
         "${dateTime.day.toString().padLeft(2, '0')}"
         "${dateTime.hour.toString().padLeft(2, '0')}"
         "${dateTime.minute.toString().padLeft(2, '0')}";
}