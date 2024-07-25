class KnnSimpleVesselModel {
  final int mmsi;
  final DateTime dateTimeUtc;
  final double longitude;
  final double latitude;
  final double speedOverGround;
  final double courseOverGround;

  KnnSimpleVesselModel({
    required this.mmsi,
    required this.dateTimeUtc,
    required this.longitude,
    required this.latitude,
    required this.speedOverGround,
    required this.courseOverGround,
  });

  @override
  String toString() {
    return 'KnnSimpleVesselModel(mmsi: $mmsi, dateTimeUtc: $dateTimeUtc, longitude: $longitude, latitude: $latitude, speedOverGround: $speedOverGround, courseOverGround: $courseOverGround)';
  }
}
