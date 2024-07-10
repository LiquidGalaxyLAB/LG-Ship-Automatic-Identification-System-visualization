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

    for (var polygon in polygonCoordinates.coordinates) {
      for (var ring in polygon) {
        for (var i = 0; i < ring.length; i += 1000) {
          var point = ring[i];
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
                <tilt>60</tilt>
                <range>5000</range>
                <gx:fovy>60</gx:fovy>
                <altitude>70000</altitude>
                <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
          '''; 
        }
      }
    }

    return content;
  }

  static String buildPathOrbit(String orbitContent, String polygoneContent) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent
  <gx:Tour>
          <name>Orbit</name>
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
