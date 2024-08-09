import 'dart:math';

import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';
import 'package:latlong2/latlong.dart';

class PredictionKmlModel {
  List<LatLng> coordinates = [];
  double heading = 0.0;

  PredictionKmlModel({required this.coordinates, required this.heading});

  String generateOrbitContent() {
    String content = '';

    for (int i = 0; i < coordinates.length; i += 1) {
      content += '''
        <gx:AnimatedUpdate>
          <gx:duration>0.2</gx:duration>
          <Update>
            <targetHref></targetHref>
            <Change>
              <Placemark targetId="iconmoved">
                <styleUrl>#customIconStyle</styleUrl>
                <Point>
                  <coordinates>${coordinates[i].longitude},${coordinates[i].latitude},$heading</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>0.2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>${coordinates[i].longitude}</longitude>
            <latitude>${coordinates[i].latitude}</latitude>
            <heading>0</heading>
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

  Future<String> generatePredictionKML() async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    String pathContent = coordinates.map((LatLng point) {
      return '${point.longitude},${point.latitude},0';
    }).join(' ');

    String orbitContent = generateOrbitContent();

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent

    <Style id="redLineStyle">
      <LineStyle>
        <color>ff0000ff</color>
        <width>4</width>
      </LineStyle>
    </Style>

    <Placemark>
      <name>Red Line</name>
      <styleUrl>#redLineStyle</styleUrl>
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
        <coordinates>${coordinates[0].longitude},${coordinates[0].latitude},$heading</coordinates>
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
