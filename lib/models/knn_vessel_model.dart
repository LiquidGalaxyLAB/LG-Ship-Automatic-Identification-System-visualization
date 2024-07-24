class KnnVesselModel {
  final int mmsi;
  final DateTime dateTimeUtc;
  final double longitude;
  final double latitude;
  final double courseOverGround;
  final double speedOverGround;
  final int aisMessageNumber;
  final double calcSpeed;
  final double secondsToPreviousPoint;
  final double distanceToPreviousPoint;

  KnnVesselModel({
    required this.mmsi,
    required this.dateTimeUtc,
    required this.longitude,
    required this.latitude,
    required this.courseOverGround,
    required this.speedOverGround,
    required this.aisMessageNumber,
    required this.calcSpeed,
    required this.secondsToPreviousPoint,
    required this.distanceToPreviousPoint,
  });

  // Factory constructor to create an instance from a list
  factory KnnVesselModel.fromList(List<dynamic> data) {
    return KnnVesselModel(
      mmsi: data[0] as int,
      dateTimeUtc: DateTime.parse(data[1] as String),
      longitude: (data[2] as num).toDouble(),
      latitude: (data[3] as num).toDouble(),
      courseOverGround: (data[4] as num).toDouble(),
      speedOverGround: (data[5] as num).toDouble(),
      aisMessageNumber: data[6] as int,
      calcSpeed: (data[7] as num).toDouble(),
      secondsToPreviousPoint: (data[8] as num).toDouble(),
      distanceToPreviousPoint: (data[9] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'KnnVesselModel(mmsi: $mmsi, dateTimeUtc: $dateTimeUtc, longitude: $longitude, latitude: $latitude, courseOverGround: $courseOverGround, speedOverGround: $speedOverGround, aisMessageNumber: $aisMessageNumber, calcSpeed: $calcSpeed, secondsToPreviousPoint: $secondsToPreviousPoint, distanceToPreviousPoint: $distanceToPreviousPoint)';
  }
}