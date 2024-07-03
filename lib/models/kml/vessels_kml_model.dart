import 'package:ais_visualizer/models/vessel_sampled_model.dart';

class VesselKmlModel {
  List<VesselSampled> vessels;

  VesselKmlModel({required this.vessels});

  String generateKml() {
    String placemarks = vessels.map((vessel) => '''
      <Placemark>
        <name>${vessel.name}</name>
        <Point>
          <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
        </Point>
      </Placemark>
    ''').join('\n');

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Vessels</name>
    <open>1</open>
    $placemarks
  </Document>
</kml>
    ''';
  }
}