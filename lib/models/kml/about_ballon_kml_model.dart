import 'package:ais_visualizer/utils/constants/text.dart';

class AboutBalloonKmlModel {
  String id;
  String name;
  double lat;
  double lng;
  String aboutAIS;
  String aboutDescription;
  String keyFeatures;
  List<String> features;

  AboutBalloonKmlModel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.aboutAIS,
    required this.aboutDescription,
    required this.keyFeatures,
    required this.features,
  });

  String generateKml() {
    String featuresList = features
        .map((feature) =>
            '<li style="color: rgba(2, 48, 71, 255);">$feature</li>')
        .join('');

    String balloonContent = '''
      <![CDATA[<!DOCTYPE html>
      <html>
        <head></head>
        <body style="background:#FFFFFF;">
          <h1 style="color: rgba(255,131, 14, 255);">$aboutAIS</h1>
          <p style="color: rgba(2, 48, 71, 255);">$aboutDescription</p>
          <h2 style="color: rgba(255,131, 14, 255);">$keyFeatures</h2>
          <ul>
            $featuresList
          </ul>
        </body>
      </html>]]>
    ''';

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>About AIS Visualization Tool</name>
    <open>1</open>
    <Style id="balloon-$id">
      <BalloonStyle>
        <bgColor>ffffffff</bgColor>
        <text>$balloonContent</text>
      </BalloonStyle>
      <LabelStyle>
        <scale>0</scale>
      </LabelStyle>
      <IconStyle>
        <scale>0</scale>
      </IconStyle>
    </Style>
    <Placemark id="$id">
      <name>$name</name>
      <description><![CDATA[
        This is a quick info on AIS Visualizer
      ]]></description>
      <styleUrl>#balloon-$id</styleUrl>
      <Point>
        <coordinates>$lng,$lat,0</coordinates>
      </Point>
      <gx:balloonVisibility>1</gx:balloonVisibility>
      <open>1</open>
    </Placemark>
  </Document>
</kml>
    ''';
  }

  factory AboutBalloonKmlModel.fromAppTexts({
    required String id,
    required String name,
    required double lat,
    required double lng,
  }) {
    return AboutBalloonKmlModel(
      id: id,
      name: name,
      lat: lat,
      lng: lng,
      aboutAIS: AppTexts.aboutAIS,
      aboutDescription: AppTexts.aboutDescription,
      keyFeatures: AppTexts.keyFeatures,
      features: AppTexts.features,
    );
  }
}

void main() {
  // Example usage
  AboutBalloonKmlModel aboutModel = AboutBalloonKmlModel.fromAppTexts(
    id: '1',
    name: 'About AIS Visualization Tool',
    lat: 37.7749, // Example latitude
    lng: -122.4194, // Example longitude
  );
  String kml = aboutModel.generateKml();
  print(kml);
}
