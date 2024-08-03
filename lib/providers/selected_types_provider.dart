import 'package:flutter/material.dart';

class SelectedTypesProvider with ChangeNotifier {
  List<String> _selectedTypes = [];

  List<String> get selectedTypes => _selectedTypes;

  void setSelectedTypes(List<String> types) {
    _selectedTypes = types;
    notifyListeners();
  }
}
