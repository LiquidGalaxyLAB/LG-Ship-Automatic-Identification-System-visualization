import 'package:flutter/material.dart';

class RouteTrackerState extends ChangeNotifier {
  bool _showVesselRoute = false;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  double _currentPosition = -1.0;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFetching = false;
  bool _sendOrbitToLg = false;
  bool _showLGBotton = false;
  int _timeInMilliSeconds = 0;

  bool get showVesselRoute => _showVesselRoute;
  bool get isPlaying => _isPlaying;
  double get playbackSpeed => _playbackSpeed;
  double get currentPosition => _currentPosition;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isFetching => _isFetching;
  bool get sendOrbitToLg => _sendOrbitToLg;
  bool get showLGBotton => _showLGBotton;
  int get timeInMilliSeconds => _timeInMilliSeconds;

  void toggleShowRoute(bool value) {
    _showVesselRoute = value;
    notifyListeners();
  }

  void toggleIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void setPlaybackSpeed(double speed) {
    _playbackSpeed = speed;
    notifyListeners();
  }

  void setCurrentPosition(double position) {
    _currentPosition = position;
    notifyListeners();
  }

  void updateDates(DateTime newStartDate, DateTime newEndDate) {
    _startDate = newStartDate;
    _endDate = newEndDate;
    notifyListeners();
  }

  void toggleIsFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void toggleSendOrbitToLg(bool value) {
    _sendOrbitToLg = value;
    notifyListeners();
  }

  void toggleShowLGBotton(bool value) {
    _showLGBotton = value;
    notifyListeners();
  }

  void setTimeInMilliSeconds(int timeInMilliSeconds) {
    _timeInMilliSeconds = timeInMilliSeconds;
    notifyListeners();
  }

  void resetState() {
    _showVesselRoute = false;
    _isPlaying = false;
    _playbackSpeed = 1.0;
    _currentPosition = -1.0;
    _startDate = null;
    _endDate = null;
    _isFetching = false;
    _sendOrbitToLg = false;
    _showLGBotton = false;
    notifyListeners();
  }
}
