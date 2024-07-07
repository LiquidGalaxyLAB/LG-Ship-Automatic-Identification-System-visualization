import 'package:flutter/material.dart';

class AisConnectionStatusProvider extends ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void updateConnectionStatus(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }
}
