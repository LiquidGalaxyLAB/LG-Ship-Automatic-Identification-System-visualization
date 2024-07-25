import 'dart:math';
import 'package:ais_visualizer/models/knn_vessel_model.dart';
import 'package:ais_visualizer/models/knn_simple_vessel_model.dart';
import 'package:ais_visualizer/services/ais_data_service.dart';

class KnnService {
  KnnService._internal();
  static final KnnService _singleton = KnnService._internal();
  factory KnnService() => _singleton;

  List<KnnSimpleVesselModel> _data = [];

  double _calculateEuclideanDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final dx = lat2 - lat1;
    final dy = lon2 - lon1;
    return sqrt(dx * dx + dy * dy);
  }

  double _normalize(double value, double min, double max) {
    return (value - min) / (max - min);
  }

  double calculateSimilarity(
      KnnSimpleVesselModel target, KnnSimpleVesselModel candidate,
      {double weightSpatial = 0.33,
      double weightSpeed = 0.33,
      double weightCourse = 0.34}) {
    final ds = _calculateEuclideanDistance(target.latitude, target.longitude,
        candidate.latitude, candidate.longitude);
    final dv = (target.speedOverGround - candidate.speedOverGround).abs();
    final dc = (target.courseOverGround - candidate.courseOverGround).abs();

    final dsNormalized = _normalize(ds, 0, 1);
    final dvNormalized = _normalize(dv, 0, 1);
    final dcNormalized = _normalize(dc, 0, 1);

    return weightSpatial * dsNormalized +
        weightSpeed * dvNormalized +
        weightCourse * dcNormalized;
  }

  void train(List<KnnVesselModel> data) {
    _data = data
        .map((vessel) => KnnSimpleVesselModel(
              mmsi: vessel.mmsi,
              dateTimeUtc: vessel.dateTimeUtc,
              longitude: vessel.longitude,
              latitude: vessel.latitude,
              speedOverGround: vessel.speedOverGround,
              courseOverGround: vessel.courseOverGround,
            ))
        .toList();
  }

  List<KnnSimpleVesselModel> predict(KnnSimpleVesselModel target, int k) {
    final similarities = _data.map((candidate) {
      final similarity = calculateSimilarity(target, candidate);
      return {'vessel': candidate, 'similarity': similarity};
    }).toList();

    // Sort the vessels by similarity in ascending order
    similarities.sort((a, b) {
      final similarityA = a['similarity'] as double;
      final similarityB = b['similarity'] as double;

      return similarityA.compareTo(similarityB);
    });

    return similarities
        .take(k)
        .map((item) => item['vessel'] as KnnSimpleVesselModel)
        .toList();
  }

  double calculateBearing(double x0, double y0, double x1, double y1) {
    double deltaX = x1 - x0;
    double deltaY = y1 - y0;
    double angle = atan2(deltaY, deltaX) * 180 / pi;
    return (angle + 360) % 360; // First ensure that angle is not negative then normalize angle to [0, 360) range
  }

  Future<Map<String, double>> predictFutureLocation(
      KnnSimpleVesselModel targetVessel,
      KnnSimpleVesselModel similarVessel) async {

    final positions = await AisDataService().fetchNextPosition(
        similarVessel.mmsi,
        similarVessel.dateTimeUtc.toIso8601String(),
        similarVessel.longitude,
        similarVessel.latitude);

    double x0 = targetVessel.longitude;
    double y0 = targetVessel.latitude;
    double x1 = positions['lngNext']!;
    double y1 = positions['latNext']!;

    double bearing = calculateBearing(x0, y0, x1, y1);

    double distance = sqrt(pow(x1 - x0, 2) + pow(y1 - y0, 2));


    // Convert bearing to radians for trigonometric functions
    double bearingRad = bearing * pi / 180;
    double futureLng = x1 + distance * sin(bearingRad);
    double futureLat = y1 + distance * cos(bearingRad);

    return {
      'futureLng': futureLng,
      'futureLat': futureLat,
    };
  }
}
