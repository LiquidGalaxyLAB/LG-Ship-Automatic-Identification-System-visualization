class LineKmlModel {
  String id;

  List<Map<String, double>> coordinates;
  double drawOrder;
  String altitudeMode;

  LineKmlModel({
    required this.id,
    required this.coordinates,
    this.drawOrder = 0,
    this.altitudeMode = 'relativeToGround',
  });

  String get tag => '''
      <Polygon id="$id">
        <extrude>0</extrude>
        <altitudeMode>$altitudeMode</altitudeMode>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
              $linearCoordinates
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    ''';

  /// Example
  /// ```
  /// LineKmlModel line = LineKmlModel(
  ///   ...
  ///   coordinates: [
  ///     {
  ///       'lng': 32,
  ///       'lat': -74,
  ///       'altitude': 0,
  ///     },
  ///     {
  ///       'lng': 34,
  ///       'lat': -78,
  ///       'altitude': 0,
  ///     },
  ///   ],
  ///   ...
  /// )
  /// line.linearCoordinates => '32,-74,0 34,-78,0'
  /// ```
  String get linearCoordinates {
    String coords = coordinates
        .map((coord) => '${coord['lng']},${coord['lat']},${coord['altitude']}')
        .join(' ');

    return coords;
  }

  /// Returns a [Map] from the current [LineKmlModel].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coordinates': coordinates,
      'altitudeMode': altitudeMode,
      'drawOrder': drawOrder,
    };
  }

  /// Returns a [LineKmlModel] from the given [map].
  factory LineKmlModel.fromMap(Map<String, dynamic> map) {
    return LineKmlModel(
      id: map['id'],
      coordinates: map['coordinates'],
      altitudeMode: map['altitudeMode'],
      drawOrder: map['drawOrder'],
    );
  }
}
