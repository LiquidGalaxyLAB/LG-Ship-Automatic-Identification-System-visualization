import 'package:ais_visualizer/models/vessel_sampled_model.dart';

class CollisionBallonKmlModel {
  VesselSampled ownVessel;
  VesselSampled targetVessel;
  bool isCollision = false;
  double cpa = 0.0;
  double tcpa = 0.0;

  CollisionBallonKmlModel(
      {required this.ownVessel,
      required this.targetVessel,
      required this.isCollision,
      required this.cpa,
      required this.tcpa});

  String generateKml() {
    String riskContent = isCollision
        ? '<p style="color: red;font-size: 16px;"><strong>Collision Risk:</strong> High</p>'
        : '<p style="color: green;font-size: 16px;"><strong>Collision Risk:</strong> Low</p>';

    String balloonContent = '''
      <![CDATA[<!DOCTYPE html>
      <html>
        <head>
          <style>
            .card {
              background-color: #FFFFFF;
              border: 1px solid #FFFFFF;
              border-radius: 5px;
              padding: 16px;
              margin-bottom: 10px;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2)
            }
            .header {
              color: rgba(2, 48, 71, 255);
              font-size: 18px;
              margin-bottom: 10px;
            }
            .content {
              background-color: rgba(223, 226, 233, 255);
              border: 1px solid rgba(223, 226, 233, 255);
              font-size: 16px;
              border-radius: 5px;
              padding: 10px;
              color: rgba(2, 48, 71, 255);
              box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
            }
            .header-content {
              color: rgba(2, 48, 71, 255);
              font-size: 16px;
              padding: 10px;
            }
            body {
              background: rgba(245, 245, 245, 255);
              font-family: Arial, sans-serif;
            }
          </style>
        </head>
        <body style="background: rgba(245, 245, 245, 255);">
          <h1 style="color: rgba(225, 131, 14, 1.0);">Collision Risk Strategy</h1>
          <div class="header-content">
            <p ><strong>Own Vessel MMSI</strong> ${ownVessel.mmsi}</p>
            <p><strong>Target Vessel MMSI</strong> ${targetVessel.mmsi}</p>
          </div>
          <div class="card">
            <h2 class="header">Calculations Result</h2>
            <div class="content">
              <p><strong>Closest Point of Approach (CPA): </strong> $cpa</p>
              <p><strong>Time to Closest Point of Approach (TCPA): </strong> $tcpa</p>
            </div>
            $riskContent
          </div>
        </body>
      </html>]]>
    ''';

    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>Vessel Information</name>
    <open>1</open>
    <Style id="balloon-${ownVessel.mmsi}">
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
    <Placemark id="${ownVessel.mmsi}">
      <name>${ownVessel.name ?? 'Unknown ownVessel'}</name>
      <description><![CDATA[
        This is a quick info on the ownVessel
      ]]></description>
      <styleUrl>#balloon-${ownVessel.mmsi}</styleUrl>
      <Point>
        <coordinates>${ownVessel.longitude},${ownVessel.latitude},0</coordinates>
      </Point>
      <gx:balloonVisibility>1</gx:balloonVisibility>
      <open>1</open>
    </Placemark>
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
