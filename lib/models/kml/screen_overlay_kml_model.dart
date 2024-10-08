class ScreenOverlayKmlModel {
  String name;
  String icon;
  double overlayX;
  double overlayY;
  double screenX;
  double screenY;
  double sizeX;
  double sizeY;

  ScreenOverlayKmlModel({
    required this.name,
    this.icon = '',
    this.overlayX = 0,
    this.overlayY = 0,
    this.screenX = 0,
    this.screenY = 0,
    this.sizeX = 0,
    this.sizeY = 0,
  });

  String get body => '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>$name</name>
    <open>1</open>
    <Folder>
      $screenOverlayTag
    </Folder>
  </Document>
</kml>
  ''';

  String get screenOverlayTag => '''
    <ScreenOverlay>
      <Icon>
        <href>$icon</href>
      </Icon>
      <color>ffffffff</color>
      <overlayXY x="$overlayX" y="$overlayY" xunits="fraction" yunits="fraction"/>
      <screenXY x="$screenX" y="$screenY" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="$sizeX" y="$sizeY" xunits="pixels" yunits="pixels"/>
    </ScreenOverlay>
  ''';

  /// Generates a KML with the default logo data in it.
  static String generateLogo() {
    ScreenOverlayKmlModel model = ScreenOverlayKmlModel(
      name: 'Logo Overlay KML',
      icon: 'https://i.imgur.com/nXz0W87.png',
      overlayX: 0.5,
      overlayY:
          1.0, // Bottom edge of the overlay aligns with the top edge of the screen
      screenX: 0.5, // Center horizontally
      screenY: 1.0 - 0.05, // Top edge of the screen with a small margin
      sizeX: 0,
      sizeY: 0,
    );
    return model.body;
  }
}
