import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RoutePredictionState extends ChangeNotifier {
  bool _showVesselRoute = false;
  bool _isFetching = false;
  List<LatLng> predictedPoints = [];

  bool get showVesselRoute => _showVesselRoute;
  bool get isFetching => _isFetching;

  void toggleShowRoute(bool value) {
    _showVesselRoute = value;
    notifyListeners();
  }

  void toggleIsFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void setPredictedPoints(List<LatLng> points) {
    predictedPoints = points;
    notifyListeners();
  }

  void resetState() {
    _showVesselRoute = false;
    _isFetching = false;
    predictedPoints = [];
    notifyListeners();
  }
}
