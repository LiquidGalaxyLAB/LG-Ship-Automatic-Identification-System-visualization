import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:ais_visualizer/utils/helpers.dart';

class CollisionKmlModel {
  VesselSampled ownVessel;
  VesselSampled targetVessel;
  LatLng? collisionPoint;

  CollisionKmlModel({
    required this.ownVessel,
    required this.targetVessel,
    required this.collisionPoint,
  });

  Future<String> generateKmlCollision() async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();

    String polylineStyle = '''
      <Style id="polylineStyle">
        <LineStyle>
          <color>ff0000ff</color> <!-- Red color with full opacity -->
          <width>4</width>
        </LineStyle>
      </Style>
    ''';

    String placemark = '''
      <Style id="ownVesselStyle">
        <IconStyle>
          <scale>1.8</scale>
          <heading>${ownVessel.trueHeading}</heading>
          <Icon>
            <href>https://imgur.com/Ao7sMGX.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark>
        <name>${escapeXml(ownVessel.name)}</name>
        <styleUrl>#ownVesselStyle</styleUrl>
        <Point>
          <coordinates>${ownVessel.longitude},${ownVessel.latitude},0</coordinates>
        </Point>
      </Placemark>

      <Style id="targetVesselStyle">
        <IconStyle>
          <scale>1.8</scale>
          <heading>${targetVessel.trueHeading}</heading>
          <Icon>
            <href>https://imgur.com/Ao7sMGX.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark id="targetVesselMoved">
        <name>${escapeXml(targetVessel.name)}</name>
        <styleUrl>#targetVesselStyle</styleUrl>
        <Point>
          <coordinates>${targetVessel.longitude},${targetVessel.latitude},0</coordinates>
        </Point>
      </Placemark>

      <Placemark>
        <name>Own Vessel to Collision Point</name>
        <styleUrl>#polylineStyle</styleUrl>
        <LineString>
          <coordinates>
            ${ownVessel.longitude},${ownVessel.latitude},0
            ${collisionPoint!.longitude},${collisionPoint!.latitude},0
          </coordinates>
        </LineString>
      </Placemark>

      <Placemark>
        <name>Target Vessel to Collision Point</name>
        <styleUrl>#polylineStyle</styleUrl>
        <LineString>
          <coordinates>
            ${targetVessel.longitude},${targetVessel.latitude},0
            ${collisionPoint!.longitude},${collisionPoint!.latitude},0
          </coordinates>
        </LineString>
      </Placemark>
    ''';

    // Generate KML tour for the movement of vessels
    String targetVesselTour =
        _generateVesselTour('targetVessel', targetVessel, collisionPoint!);

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent
    $polylineStyle
    <Style id="collisionMarkerStyle">
      <IconStyle>
        <scale>1.8</scale>
        <Icon>
          <href>https://imgur.com/Ao7sMGX.png</href>
        </Icon>
      </IconStyle>
    </Style>
    <name>Vessels and Collision</name>
    $placemark
    <gx:Tour>
      <name>VesselCollisionTour</name>
      <gx:Playlist>
        $targetVesselTour
      </gx:Playlist>
    </gx:Tour>
  </Document>
</kml>
    ''';
  }

  String _generateVesselTour(
      String vesselId, VesselSampled vessel, LatLng collisionPoint) {
    List<LatLng> coordinates = _generateCoordinates(vessel, collisionPoint);
    StringBuffer tourBuffer = StringBuffer();

    for (int i = 0; i < coordinates.length; i++) {
      tourBuffer.writeln('''
        <gx:AnimatedUpdate>
          <gx:duration>0.3</gx:duration>
          <Update>
            <targetHref></targetHref>
            <Change>
              <Placemark targetId="${vesselId}Moved">
                <styleUrl>#${vesselId}Style</styleUrl>
                <Point>
                  <coordinates>${coordinates[i].longitude},${coordinates[i].latitude},0</coordinates>
                </Point>
              </Placemark>
            </Change>
          </Update>
        </gx:AnimatedUpdate>

        <gx:FlyTo>
          <gx:duration>0.3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>${coordinates[i].longitude}</longitude>
            <latitude>${coordinates[i].latitude}</latitude>
            <heading>${vessel.trueHeading}</heading>
            <tilt>60</tilt>
            <range>1000</range>
            <gx:fovy>0</gx:fovy>
            <altitude>500</altitude>
            <gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>0.3</gx:duration>  
        </gx:Wait>
      ''');
    }

    return tourBuffer.toString();
  }

  List<LatLng> _generateCoordinates(
      VesselSampled vessel, LatLng collisionPoint) {
    // Simple linear interpolation
    int numPoints = 25;
    List<LatLng> coordinates = [];
    double latStep = (collisionPoint.latitude - vessel.latitude!) / numPoints;
    double lonStep = (collisionPoint.longitude - vessel.longitude!) / numPoints;

    for (int i = 0; i <= numPoints; i++) {
      double lat = vessel.latitude! + i * latStep;
      double lon = vessel.longitude! + i * lonStep;
      coordinates.add(LatLng(lat, lon));
    }

    return coordinates;
  }
}
