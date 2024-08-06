import 'package:flutter/material.dart';

class FilterRegionProvider extends ChangeNotifier {
  bool _filterRegion = false;
  bool _enableFilterMap = false;

  bool get filterRegion => _filterRegion;
  bool get enableFilterMap => _enableFilterMap;

  void setFilterRegion(bool value) {
    _filterRegion = value;
    notifyListeners();
  }

  void setEnableFilterMap(bool value) {
    _enableFilterMap = value;
    notifyListeners();
  }
}