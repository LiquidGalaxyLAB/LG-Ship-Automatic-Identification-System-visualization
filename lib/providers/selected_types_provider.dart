import 'package:flutter/material.dart';

class SelectedTypesProvider with ChangeNotifier {
  List<String> _selectedTypes = [];
  List<int> _selectedTypesIndex = [];

  List<String> get selectedTypes => _selectedTypes;
  List<int> get selectedTypesIndex => _selectedTypesIndex;

  void setSelectedTypes(List<String> types, List<int> indexTypes) {
    _selectedTypes = types;
    _selectedTypesIndex = indexTypes;
    notifyListeners();
  }
}
