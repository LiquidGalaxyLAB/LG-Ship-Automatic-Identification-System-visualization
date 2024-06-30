import 'package:flutter/material.dart';

class SelectedVesselProvider extends ChangeNotifier {
  int _selectedMMSI = -1;
  int _previousMMSI = -2;

  int get selectedMMSI => _selectedMMSI;
  int get previousMMSI => _previousMMSI;

  void updateSelectedVessel(int mmsi) {
    _previousMMSI = _selectedMMSI;
    _selectedMMSI = mmsi;
    notifyListeners();
  }
}
