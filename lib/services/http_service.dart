import 'package:ais_visualizer/utils/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AisHttpService {
  static final AisHttpService _singleton = AisHttpService._internal();
  final _dio = Dio();

  factory AisHttpService() {
    return _singleton;
  }

  AisHttpService._internal() {
    setup();
  }

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    final bearerToken = prefs.getString('access_token');
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $bearerToken',
    };
    final options = BaseOptions(
      baseUrl: ApiConstants.baseURL,
      headers: headers,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );
    _dio.options = options;
  }

  Future<Response?> post(String path, Map data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      print('Failed to post data: $e');
    }
    return null;
  }

  Future<Response?> get(String path, {String? bearerToken}) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      print('Failed to get data: $e');
    }
    return null;
  }
}
