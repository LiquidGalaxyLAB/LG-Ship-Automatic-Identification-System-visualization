import 'package:flutter/material.dart';

class SelectedVesselProvider extends ChangeNotifier {
  int _selectedMMSI = -1;

  int get selectedMMSI => _selectedMMSI;

  void updateSelectedVessel(int mmsi) {
    _selectedMMSI = mmsi;
    notifyListeners();
  }
}
