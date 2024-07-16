import 'package:ais_visualizer/models/vessel_full_model.dart';
import 'package:ais_visualizer/utils/constants/text.dart';


class VesselInfoBalloonKmlModel {
  VesselFull vessel;

  VesselInfoBalloonKmlModel({required this.vessel});

  String generateKml() {
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
          <h1 style="color: rgba(225, 131, 14, 1.0);">Vessel Information</h1>
          <div class="header-content">
            <p ><strong>${AppTexts.name}</strong> ${_escapeXml(vessel.name)}</p>
            <p><strong>${AppTexts.mmsi}</strong> ${vessel.mmsi}</p>
            <p ><strong>${AppTexts.signalReceived}:</strong> ${vessel.msgtime}</p>
          </div>
          <div class="card">
            <h2 class="header">${AppTexts.navigationDetails}</h2>
            <div class="content">
              <p><strong>${AppTexts.speedOverGround}</strong> ${vessel.speedOverGround ?? 'N/A'}</p>
              <p><strong>${AppTexts.courseOverGround}</strong> ${vessel.courseOverGround ?? 'N/A'}</p>
              <p><strong>${AppTexts.navigationalStatus}</strong> ${vessel.navigationalStatus ?? 'N/A'}</p>
              <p><strong>${AppTexts.rateOfTurn}</strong> ${vessel.rateOfTurn ?? 'N/A'}</p>
              <p><strong>${AppTexts.heading}</strong> ${vessel.trueHeading ?? 'N/A'}</p>
              <p><strong>${AppTexts.lastKnownPosition}</strong> ${vessel.latitude ?? 'N/A'}, ${vessel.longitude ?? 'N/A'}</p>
            </div>
          </div>
          <div class="card">
            <h2 class="header">${AppTexts.vesselCharacteristics}</h2>
            <div class="content">
              <p><strong>${AppTexts.shipType}</strong> ${vessel.shipType ?? 'N/A'}</p>
              <p><strong>${AppTexts.callSign}</strong> ${vessel.callSign ?? 'N/A'}</p>
              <p><strong>${AppTexts.destination}</strong> ${vessel.destination ?? 'N/A'}</p>
              <p><strong>${AppTexts.estimatedArrival}</strong> ${vessel.eta ?? 'N/A'}</p>
              <p><strong>${AppTexts.imoNumber}</strong> ${vessel.imoNumber ?? 'N/A'}</p>
              <p><strong>${AppTexts.draught}</strong> ${vessel.draught ?? 'N/A'}</p>
            </div>
          </div>
          <div class="card">
            <h2 class="header">${AppTexts.physicalDimensions}</h2>
            <div class="content">
              <p><strong>${AppTexts.dimensionA}</strong> ${vessel.dimensionA ?? 'N/A'}</p>
              <p><strong>${AppTexts.dimensionB}</strong> ${vessel.dimensionB ?? 'N/A'}</p>
              <p><strong>${AppTexts.dimensionC}</strong> ${vessel.dimensionC ?? 'N/A'}</p>
              <p><strong>${AppTexts.dimensionD}</strong> ${vessel.dimensionD ?? 'N/A'}</p>
              <p><strong>${AppTexts.shipLength}</strong> ${vessel.shipLength ?? 'N/A'}</p>
              <p><strong>${AppTexts.shipWidth}</strong> ${vessel.shipWidth ?? 'N/A'}</p>
            </div>
          </div>
          <div class="card">
            <h2 class="header">${AppTexts.positioningDetails}</h2>
            <div class="content">
              <p><strong>${AppTexts.positionFixingDeviceType}</strong> ${vessel.positionFixingDeviceType ?? 'N/A'}</p>
              <p><strong>${AppTexts.reportClass}</strong> ${vessel.reportClass ?? 'N/A'}</p>
            </div>
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
    <Style id="balloon-${vessel.mmsi}">
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
    <Placemark id="${vessel.mmsi}">
      <name>${vessel.name ?? 'Unknown Vessel'}</name>
      <description><![CDATA[
        This is a quick info on the vessel
      ]]></description>
      <styleUrl>#balloon-${vessel.mmsi}</styleUrl>
      <Point>
        <coordinates>${vessel.longitude},${vessel.latitude},0</coordinates>
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

void main() {
  // Example vessel data
  VesselFull vessel = VesselFull(
    mmsi: 123456789,
    msgtime: DateTime.now(),
    courseOverGround: 75.5,
    latitude: 37.7749,
    longitude: -122.4194,
    navigationalStatus: 5,
    rateOfTurn: 0.0,
    speedOverGround: 14.2,
    trueHeading: 90,
    imoNumber: 9876543,
    callSign: 'ABC123',
    name: 'Vessel Name',
    destination: 'Port of San Francisco',
    eta: '2024-06-30T12:00:00Z',
    draught: 9.5,
    shipLength: 300.0,
    shipWidth: 50.0,
    shipType: 70,
    dimensionA: 150.0,
    dimensionB: 150.0,
    dimensionC: 25.0,
    dimensionD: 25.0,
    positionFixingDeviceType: 1,
    reportClass: 'Class A',
    msgtimeStatic: DateTime.now().subtract(Duration(hours: 2)),
  );

  VesselInfoBalloonKmlModel vesselInfoBalloon = VesselInfoBalloonKmlModel(vessel: vessel);
  String kml = vesselInfoBalloon.generateKml();
  print(kml);
}
