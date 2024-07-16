import 'dart:convert';
import 'package:flutter/services.dart';

class OrbitPathKmlModel {
  static Future<String> generatePolygonOrbitContentArea(
      String assetPath) async {
    // Load and parse the JSON file
    final jsonString = await rootBundle.loadString(assetPath);
    final jsonData = jsonDecode(jsonString);
    final polygonCoordinates = PolygonCoordinates.fromJson(jsonData);

    String content = '';

    for (int polygonIndex = 0;
        polygonIndex < polygonCoordinates.coordinates.length;
        polygonIndex++) {
      var polygon = polygonCoordinates.coordinates[polygonIndex];
      int stepSize = polygonIndex == 0
          ? 500
          : 100; // Smaller step size for inner polygons

      for (var ring in polygon) {
        List<List<double>> smoothedPoints =
            interpolatePoints(ring, stepSize: stepSize);

        for (var point in smoothedPoints) {
          double lng = point[0];
          double lat = point[1];
 
          content += '''
            <gx:FlyTo>
              <gx:duration>1.2</gx:duration>
              <gx:flyToMode>smooth</gx:flyToMode>
              <LookAt>
                <longitude>$lng</longitude>
                <latitude>$lat</latitude>
                <heading>0</heading>
                <tilt>0</tilt>
                <range>50000</range>
                <gx:fovy>0</gx:fovy>
                <altitude>2000000</altitude>
                <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
          ''';
        }
      }
    }

    return content;
  }

  static List<List<double>> interpolatePoints(List<List<double>> ring,
      {int stepSize = 100}) {
    List<List<double>> smoothedPoints = [];
    int ringLength = ring.length;

    if (ringLength <= 1) {
      return ring;
    }

    for (int i = 0; i < ringLength; i += stepSize) {
      int startIndex = i % ringLength;
      int endIndex = (i + stepSize) % ringLength;

      List<double> startPoint = ring[startIndex];
      List<double> endPoint = ring[endIndex];

      // Linear interpolation between startPoint and endPoint
      double lng = (startPoint[0] + endPoint[0]) / 2;
      double lat = (startPoint[1] + endPoint[1]) / 2;

      smoothedPoints.add([lng, lat]);
    }

    return smoothedPoints;
  }

  static String buildPathOrbit(String orbitContent, String polygoneContent) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent
    <gx:Tour>
      <name>AisOrbit</name>
      <gx:Playlist> 
        $orbitContent
      </gx:Playlist>
    </gx:Tour>
  </Document>
</kml>
    ''';
  }
}

class PolygonCoordinates {
  List<List<List<List<double>>>> coordinates;
  PolygonCoordinates({required this.coordinates});

  factory PolygonCoordinates.fromJson(Map<String, dynamic> json) {
    List<dynamic> coordinatesJson = json['coordinates'];
    List<List<List<List<double>>>> coordinates = coordinatesJson
        .map((item) => (item as List)
            .map((subItem) => (subItem as List)
                .map((point) => (point as List)
                    .map((coord) => (coord as num).toDouble())
                    .toList())
                .toList())
            .toList())
        .toList();

    return PolygonCoordinates(coordinates: coordinates);
  }
}
