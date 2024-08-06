import 'dart:async';

import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class VesselKmlModel {
  List<VesselSampled> vessels;

  VesselKmlModel({required this.vessels});

  String generateMarkersOnlyKml() {
    String placemarks = vessels.map((vessel) => '''
      <Style id="customIconStyle">
        <IconStyle>
	      <scale>0.8</scale>
            <heading>${vessel.trueHeading}</heading>
          <Icon>
            <href>https://i.imgur.com/eaxfQjT.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark>
        <styleUrl>#customIconStyle</styleUrl>
        <Point>
          <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
        </Point>
      </Placemark>
    ''').join('\n');

    return '''
      $placemarks
    ''';
  }

  String generateKmlSolo() {
    String placemarks = vessels.map((vessel) => '''
      <Style id="customIconStyle">
        <IconStyle>
	      <scale>0.8</scale>
            <heading>${vessel.trueHeading}</heading>
          <Icon>
            <href>https://i.imgur.com/eaxfQjT.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark>
        <name>${_escapeXml(vessel.name)}</name>
        <styleUrl>#customIconStyle</styleUrl>
        <Point>
          <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
        </Point>
      </Placemark>
    ''').join('\n');

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Vessels</name>
    $placemarks
  </Document>
</kml>
    ''';
  }

  Future<String> generateKmlWithArea() async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    String placemarks = vessels.map((vessel) => '''
      <Style id="customIconStyle">
        <IconStyle>
	      <scale>0.8</scale>
            <heading>${vessel.trueHeading}</heading>
          <Icon>
            <href>https://i.imgur.com/eaxfQjT.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark>
        <name>${_escapeXml(vessel.name)}</name>
        <styleUrl>#customIconStyle</styleUrl>
        <Point>
          <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
        </Point>
      </Placemark>
    ''').join('\n');

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent
    <name>Vessels</name>
    $placemarks
  </Document>
</kml>
    ''';
  }

  Future<String> generateKmlWithAreaAndRegion(
      List<gmaps.LatLng> regionPoints) async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    // Convert region points to KML polygon format
    String regionPolygonContent = '';
    if (regionPoints.isNotEmpty) {
      // Ensure the polygon is closed by repeating the first point at the end
      final coordinates = [
        ...regionPoints
            .map((point) => '${point.longitude},${point.latitude},0'),
        '${regionPoints.first.longitude},${regionPoints.first.latitude},0' // Close the polygon
      ].join('\n');

      regionPolygonContent = '''
      <Placemark>
        <name>Region Area</name>
        <Style>
          <LineStyle>
            <color>ffff0000</color>
            <width>2</width>
          </LineStyle>
          <PolyStyle>
            <color>4dff0000</color>
          </PolyStyle>
        </Style>
        <Polygon>
          <outerBoundaryIs>
            <LinearRing>
              <coordinates>
                $coordinates
              </coordinates>
            </LinearRing>
          </outerBoundaryIs>
        </Polygon>
      </Placemark>
    ''';
    }

    // Create placemarks for vessels
    String placemarks = vessels.map((vessel) => '''
    <Style id="customIconStyle">
      <IconStyle>
        <scale>0.8</scale>
        <heading>${vessel.trueHeading}</heading>
        <Icon>
          <href>https://i.imgur.com/eaxfQjT.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <Placemark>
      <name>${_escapeXml(vessel.name)}</name>
      <styleUrl>#customIconStyle</styleUrl>
      <Point>
        <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
      </Point>
    </Placemark>
  ''').join('\n');

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $regionPolygonContent
    $polygoneContent
    <name>Vessels</name>
    $placemarks
  </Document>
</kml>
  ''';
  }

  String _escapeXml(String? input) {
    if (input == null || input.isEmpty) {
      return ''; // Return empty string if input is null or empty
    }
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
