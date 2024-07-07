import 'package:ais_visualizer/models/vessel_sampled_model.dart';

class VesselKmlModel {
  List<VesselSampled> vessels;

  VesselKmlModel({required this.vessels});

  String generateKml() {
    String placemarks = vessels.map((vessel) => '''
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
}