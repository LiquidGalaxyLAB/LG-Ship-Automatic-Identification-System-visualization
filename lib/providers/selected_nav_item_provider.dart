import 'package:ais_visualizer/utils/constants/text.dart';
import 'package:flutter/material.dart';

class SelectedNavItemProvider extends ChangeNotifier {
  String _selectedItem = AppTexts.navBarItems[AppTexts.navBarItems.length - 1];

  String get selectedItem => _selectedItem;

  void updateNavItem(String item) {
    _selectedItem = item;
    notifyListeners();
  }
}
