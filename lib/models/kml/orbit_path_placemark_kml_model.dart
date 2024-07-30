import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';

class OrbitPathPlacemarkKmlModel {
  static String generateOrbitContent(List<List<double>> pathCoordinates,
      {int stepSize = 100}) {
    String content = '';

    for (int i = 0; i < pathCoordinates.length; i += stepSize) {
      double lng = pathCoordinates[i][0];
      double lat = pathCoordinates[i][1];
      double heading = pathCoordinates[i][2];

      content += '''
        <gx:AnimatedUpdate>
          <gx:duration>0.1</gx:duration>
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
          <gx:duration>0.5</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>$lng</longitude>
            <latitude>$lat</latitude>
            <heading>$heading</heading>
            <tilt>0</tilt>
            <range>10000</range>
            <gx:fovy>0</gx:fovy>
            <altitude>230000</altitude>
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

    String orbitContent = generateOrbitContent(pathCoordinates);

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
