import 'package:flutter/material.dart';

class RoutePredictionState extends ChangeNotifier {
  bool _showVesselRoute = false;
  int _timeToPredict = 10;
  bool _isFetching = false;

  bool get showVesselRoute => _showVesselRoute;
  int get timeToPredict => _timeToPredict;
  bool get isFetching => _isFetching;

  void toggleShowRoute(bool value) {
    _showVesselRoute = value;
    notifyListeners();
  }

  void setTimeToPredict(int value) {
    _timeToPredict = value;
    notifyListeners();
  }

  void toggleIsFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void resetState() {
    _showVesselRoute = false;
    _timeToPredict = 10;
    _isFetching = false;
    notifyListeners();
  }
}
