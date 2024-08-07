import 'dart:math';

import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:latlong2/latlong.dart';

class CollisionService {
  CollisionService._internal();
  static final CollisionService _singleton = CollisionService._internal();
  factory CollisionService() => _singleton;

  double toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double distance(LatLng p1, LatLng p2) {
    double lat1 = toRadians(p1.latitude);
    double lon1 = toRadians(p1.longitude);
    double lat2 = toRadians(p2.latitude);
    double lon2 = toRadians(p2.longitude);

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double R = 6371000; // Earth radius in meters

    return R * c;
  }

  Map<String, dynamic> cpaTcpa(VesselSampled vessel1, VesselSampled vessel2) {
    // Convert speed and course to velocity components
    double v1x = vessel1.speedOverGround! * cos(toRadians(vessel1.courseOverGround!));
    double v1y = vessel1.speedOverGround! * sin(toRadians(vessel1.courseOverGround!));
    double v2x = vessel2.speedOverGround! * cos(toRadians(vessel2.courseOverGround!));
    double v2y = vessel2.speedOverGround! * sin(toRadians(vessel2.courseOverGround!));

    // Relative position and velocity
    double rx = vessel1.latitude! - vessel2.latitude!;
    double ry = vessel1.longitude! - vessel2.longitude!;
    double vx = v1x - v2x;
    double vy = v1y - v2y;

    // Calculate TCPA
    double dotProductRV = rx * vx + ry * vy;
    double dotProductVV = vx * vx + vy * vy;

    // Check if vessels are on parallel or diverging paths
    bool areParallelOrDiverging = dotProductVV == 0;

    // Ensure dotProductVV is not zero to avoid division by zero
    double tcpa = areParallelOrDiverging ? 0.0 : -dotProductRV / dotProductVV;

    // Ensure TCPA is non-negative (future event)
    tcpa = max(tcpa, 0.0);

    // Positions at TCPA
    LatLng vessel1AtTcpa = LatLng(
      vessel1.latitude! + v1x * tcpa / 3600.0,
      vessel1.longitude! + v1y * tcpa / 3600.0,
    );
    LatLng vessel2AtTcpa = LatLng(
      vessel2.latitude! + v2x * tcpa / 3600.0,
      vessel2.longitude! + v2y * tcpa / 3600.0,
    );

    // Calculate CPA, return in meters and hours
    double cpa = distance(vessel1AtTcpa, vessel2AtTcpa);

    // Convert TCPA to minutes and CPA to kilometers
    double tcpaInMinutes = tcpa * 60.0;
    double cpaInKilometers = cpa / 1000.0;

    print("tcpa: $tcpaInMinutes minutes, cpa: $cpaInKilometers km, areParallelOrDiverging: $areParallelOrDiverging");

    // Find intersection point (if any)
    LatLng? collisionPoint;
    if (tcpa > 0.0) {
      collisionPoint = LatLng(
        vessel1.latitude! + v1x * tcpa / 3600.0,
        vessel1.longitude! + v1y * tcpa / 3600.0,
      );
    }

    return {
      'cpa': cpaInKilometers,
      'tcpa': tcpaInMinutes,
      'collisionPoint': collisionPoint,
      'areParallelOrDiverging': areParallelOrDiverging
    };
  }
}
