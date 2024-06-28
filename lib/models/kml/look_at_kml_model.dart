class LookAtKmlModel {
  double lat;
  double lng;
  double altitude;
  String range;
  String tilt;
  String heading;
  String altitudeMode;

  LookAtKmlModel(
      {required this.lng,
      required this.lat,
      required this.range,
      required this.tilt,
      required this.heading,
      this.altitude = 0,
      this.altitudeMode = 'relativeToGround'});

  String get tag => '''
      <LookAt>
        <longitude>$lng</longitude>
        <latitude>$lat</latitude>
        <altitude>$altitude</altitude>
        <range>$range</range>
        <tilt>$tilt</tilt>
        <heading>$heading</heading>
        <gx:altitudeMode>$altitudeMode</gx:altitudeMode>
      </LookAt>
    ''';

  String get linearTag =>
      '<LookAt><longitude>$lng</longitude><latitude>$lat</latitude><altitude>$altitude</altitude><range>$range</range><tilt>$tilt</tilt><heading>$heading</heading><gx:altitudeMode>$altitudeMode</gx:altitudeMode></LookAt>';
}
