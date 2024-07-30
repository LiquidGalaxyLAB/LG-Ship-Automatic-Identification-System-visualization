import 'package:flutter/material.dart';

class SelectedKmlFileProvider extends ChangeNotifier {
  // vesselsAis.kml, vessel.kml
  String _selectedKmlFile = "";

  String get selectedKmlFile => _selectedKmlFile;

  void updateFileStatus(String kmlFile) {
    _selectedKmlFile = kmlFile;
    notifyListeners();
  }
}
