import 'package:flutter/material.dart';

class RoutePredictionState extends ChangeNotifier {
  bool _showVesselRoute = false;
  bool _isFetching = false;

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

  void resetState() {
    _showVesselRoute = false;
    _isFetching = false;
    notifyListeners();
  }
}
