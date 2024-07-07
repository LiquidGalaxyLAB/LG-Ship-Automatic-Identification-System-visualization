import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VesselSampled with ClusterItem {
  double? courseOverGround;
  double? latitude;
  double? longitude;
  String? name;
  int? rateOfTurn;
  int? shipType;
  double? speedOverGround;
  int? trueHeading;
  int? navigationalStatus;
  int? mmsi;
  DateTime? msgtime;

  VesselSampled({
    this.courseOverGround,
    this.latitude,
    this.longitude,
    this.name,
    this.rateOfTurn,
    this.shipType,
    this.speedOverGround,
    this.trueHeading,
    this.navigationalStatus,
    this.mmsi,
    this.msgtime,
  });

  factory VesselSampled.fromJson(Map<String, dynamic> json) {
    return VesselSampled(
      courseOverGround: json['courseOverGround']?.toDouble(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      name: json['name'],
      rateOfTurn: json['rateOfTurn'],
      shipType: json['shipType'],
      speedOverGround: json['speedOverGround']?.toDouble(),
      trueHeading: json['trueHeading'],
      navigationalStatus: json['navigationalStatus'],
      mmsi: json['mmsi'],
      msgtime: json['msgtime'] != null ? DateTime.parse(json['msgtime']) : null,
    );
  }

  @override
  LatLng get location => LatLng(latitude!, longitude!);
}
