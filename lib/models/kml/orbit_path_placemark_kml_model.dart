import 'dart:math';

import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';

class OrbitPathPlacemarkKmlModel {
  static String generateOrbitContent(List<List<double>> pathCoordinates,
      {int stepSize = 5, double minDistance = 30.0}) {
    String content = '';

    double haversineDistance(
        double lat1, double lon1, double lat2, double lon2) {
      const R = 6371000; // Radius of Earth in meters
      double dLat = (lat2 - lat1) * pi / 180.0;
      double dLon = (lon2 - lon1) * pi / 180.0;

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1 * pi / 180.0) *
              cos(lat2 * pi / 180.0) *
              sin(dLon / 2) *
              sin(dLon / 2);

      double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      return R * c;
    }

    List<List<double>> filteredPathCoordinates = [];
    if (pathCoordinates.isNotEmpty) {
      filteredPathCoordinates.add(pathCoordinates[0]);

      for (int i = 1; i < pathCoordinates.length; i++) {
        double prevLat = filteredPathCoordinates.last[1];
        double prevLng = filteredPathCoordinates.last[0];
        double currLat = pathCoordinates[i][1];
        double currLng = pathCoordinates[i][0];

        double distance = haversineDistance(prevLat, prevLng, currLat, currLng);

        if (distance >= minDistance) {
          filteredPathCoordinates.add(pathCoordinates[i]);
        }
      }
    }

    for (int i = 0; i < filteredPathCoordinates.length; i += stepSize) {
      double lng = filteredPathCoordinates[i][0];
      double lat = filteredPathCoordinates[i][1];
      double heading = filteredPathCoordinates[i][2];

      content += '''.
        <gx:AnimatedUpdate>
          <gx:duration>0.2</gx:duration>
          <Update>
            <targetHref></targetHref>
            <Change>
              <Placemark targetId="iconmoved">
                <styleUrl>#customIconStyle</styleUrl>
                <Point>
                  <coordinates>$lng,$lat,$heading</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>0.2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>$lng</longitude>
            <latitude>$lat</latitude>
            <heading>$heading</heading>
            <tilt>60</tilt>
            <range>10000</range>
            <gx:fovy>0</gx:fovy>
            <altitude>500</altitude>
            <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>0.3</gx:duration>  
        </gx:Wait>
      ''';
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

  static Future<String> buildPathOrbit(
      List<List<double>> pathCoordinates) async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    String pathContent = pathCoordinates.map((point) {
      return '${point[0]},${point[1]},0';
    }).join(' ');

    String orbitContent = generateOrbitContent(pathCoordinates, stepSize: 10);

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent

    <Style id="greenLineStyle">
      <LineStyle>
        <color>ff00ff00</color> <!-- Green (in ABGR format) -->
        <width>4</width>
      </LineStyle>
    </Style>

    <Placemark>
      <name>Green Line</name>
      <styleUrl>#greenLineStyle</styleUrl>
      <LineString>
        <coordinates>
          $pathContent
        </coordinates>
      </LineString>
    </Placemark>

    <Style id="customIconStyle">
      <IconStyle>
        <scale>1.8</scale>
        <heading>0</heading>
        <Icon>
          <href>https://imgur.com/Ao7sMGX.png</href>
        </Icon>
      </IconStyle>
    </Style>

    <Placemark id="iconmoved">
      <name>Vessel</name>
      <styleUrl>#customIconStyle</styleUrl>
      <Point>
        <coordinates>${pathCoordinates[0][0]},${pathCoordinates[0][1]},${pathCoordinates[0][2]}</coordinates>
      </Point>
    </Placemark>

    <gx:Tour>
      <name>PathOrbit</name>
      <gx:Playlist> 
        $orbitContent
      </gx:Playlist>
    </gx:Tour>
  </Document>
</kml>
    ''';
  }
}
