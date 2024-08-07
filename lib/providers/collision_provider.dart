import 'package:ais_visualizer/models/vessel_sampled_model.dart';
import 'package:flutter/material.dart';

class CollisionProvider extends ChangeNotifier {
  VesselSampled? _ownVessel = null;
  VesselSampled? _targetVessel = null;
  bool _isInCollision = false;

  VesselSampled? get ownVessel => _ownVessel;
  VesselSampled? get targetVessel => _targetVessel;
  bool get isInCollision => _isInCollision;

  void setOwnVessel(VesselSampled? vessel) {
    _ownVessel = vessel;
  }

  void setTargetVessel(VesselSampled? vessel) {
    _targetVessel = vessel;
    notifyListeners();
  }

  void setIsInCollision(bool isInCollision) {
    _isInCollision = isInCollision;
    notifyListeners();
  }

  void reset() {
    _ownVessel = null;
    _targetVessel = null;
    _isInCollision = false;
    notifyListeners();
  }
}
