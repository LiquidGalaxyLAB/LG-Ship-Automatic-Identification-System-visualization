import 'package:flutter/material.dart';

class RouteTrackerState extends ChangeNotifier {
  bool _showVesselRoute  = false;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  double _currentPosition = -1.0;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFetching = false;


  bool get showVesselRoute  => _showVesselRoute ;
  bool get isPlaying => _isPlaying;
  double get playbackSpeed => _playbackSpeed;
  double get currentPosition => _currentPosition;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  bool get isFetching => _isFetching;

  void toggleShowRoute(bool value) {
    _showVesselRoute  = value;
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

  void resetState() {
    _showVesselRoute  = false;
    _isPlaying = false;
    _playbackSpeed = 1.0;
    _currentPosition = -1.0;
    _startDate = null;
    _endDate = null;
    _isFetching = false;
    notifyListeners();
  }
}