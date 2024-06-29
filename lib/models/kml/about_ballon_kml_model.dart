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
            '<li style="color: rgba(2, 48, 71, 255); font-size: 14px;">$feature</li>')
        .join('');

    String balloonContent = '''
      <![CDATA[<!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              background: rgba(245, 245, 245, 255);
              font-family: Arial, sans-serif;
            }
            .card {
              background-color: #FFFFFF;
              border: 1px solid #FFFFFF;
              border-radius: 5px;
              padding: 16px;
              margin-bottom: 10px;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }
            .images {
              display: flex;
              justify-content: center;
              align-items: center;
              margin-top: 40px;
            }
            .images img {
              margin: 0 0px;
              width: 300px;
              height: auto;
              border-radius: 5px;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }
          </style>
        </head>
        <body>
          <h1 style="color: rgba(255,131, 14, 255);">$aboutAIS</h1>
          <p style="color: rgba(2, 48, 71, 255); font-size: 16px;">$aboutDescription</p>
          <div class="card">
            <h2 style="color: rgba(255,131, 14, 255);">$keyFeatures</h2>
            <ul>
              $featuresList
            </ul>
          </div>
          <div class="images">
            <img src="https://i.imgur.com/0lEEIpf.png" alt="logo"/>
          </div>
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
