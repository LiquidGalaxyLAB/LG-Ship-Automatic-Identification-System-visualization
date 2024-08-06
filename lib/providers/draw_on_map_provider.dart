import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DrawOnMapProvider extends ChangeNotifier {
  bool _isDrawing = false;
  final List<LatLng> _polyLinesLatLngList = [];

  bool get isDrawing => _isDrawing;
  List<LatLng> get polyLinesLatLngList => _polyLinesLatLngList;

  void toggleDrawing() {
    _isDrawing = !_isDrawing;
    notifyListeners();
  }

  void addPolyLineLatLng(List<LatLng> latLng) {
    _polyLinesLatLngList.clear();
    _polyLinesLatLngList.addAll(latLng);
    notifyListeners();
  }

  void clearDrawing() {
    _polyLinesLatLngList.clear();
    notifyListeners();
  }
}
