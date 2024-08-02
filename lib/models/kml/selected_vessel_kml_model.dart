import 'package:ais_visualizer/models/kml/look_at_kml_model.dart';
import 'package:ais_visualizer/models/kml/multi_polygone_kml_model.dart';
import 'package:ais_visualizer/models/kml/orbit_kml_model.dart';
import 'package:ais_visualizer/models/vessel_sampled_model.dart';

class SelectedVesselKmlModel {
  VesselSampled vessel;

  SelectedVesselKmlModel({required this.vessel});

  String generateKmlSolo() {
    '''
      <Style id="customIconStyle">
        <IconStyle>
	      <scale>1.8</scale>
            <heading>${vessel.trueHeading}</heading>
          <Icon>
            <href>https://i.imgur.com/eaxfQjT.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark>
        <name>${vessel.name}</name>
        <styleUrl>#customIconStyle</styleUrl>
        <Point>
          <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
        </Point>
      </Placemark>
    ''';

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>Vessels</name>
    $vessel
  </Document>
</kml>
    ''';
  }

  Future<String> generateKmlWithArea() async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    String placemark = '''
      <Style id="customIconStyle">
        <IconStyle>
	      <scale>1.8</scale>
            <heading>${vessel.trueHeading}</heading>
          <Icon>
            <href>https://imgur.com/Ao7sMGX.png</href>
          </Icon>
        </IconStyle>
      </Style>
      <Placemark>
        <name>${vessel.name}</name>
        <styleUrl>#customIconStyle</styleUrl>
        <Point>
          <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
        </Point>
      </Placemark>
    ''';

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent
    <name>Vessels</name>
    $placemark
  </Document>
</kml>
    ''';
  }

  Future<String> generateKmlWithAreaAndOrbit() async {
    MultiPolygonKmlModel multiPolygon = MultiPolygonKmlModel(coordinates: []);
    String polygoneContent = await multiPolygon.getPolylineContent();
    String placemark = '''
      <Style id="customIconStyle">
        <IconStyle>
	      <scale>1.8</scale>
            <heading>${vessel.trueHeading}</heading>
          <Icon>
            <href>https://imgur.com/Ao7sMGX.png</href>
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
    ''';
    LookAtKmlModel lookAtModel = LookAtKmlModel(
      lat: vessel.latitude!,
      lng: vessel.longitude!,
      range: '10000',
      tilt: '60',
      heading: '0',
      altitude: 100,
      altitudeMode: 'relativeToSeaFloor',
    );

    String orbitContent = OrbitKmlModel.tag(lookAtModel);

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    $polygoneContent
    <name>Vessels</name>
    $placemark
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
