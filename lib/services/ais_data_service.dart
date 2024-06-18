import 'package:ais_visualizer/services/http_service.dart';

class AisDataService {
  AisDataService._internal();
  static final AisDataService _singleton = AisDataService._internal();

  final AisHttpService _httpService = AisHttpService();

  factory AisDataService() {
    return _singleton;
  }

  
}