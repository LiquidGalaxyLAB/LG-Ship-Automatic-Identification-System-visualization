import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ais_visualizer/utils/constants/api_constants.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _singleton = AuthService._internal();
  
  static const _authUrl = ApiConstants.authenticationURL;
  static final String? _clientId = dotenv.env['CLIENT_ID'];
  static final String? _clientSecret = dotenv.env['CLIENT_SECRET'];
  static final String? _scope = dotenv.env['SCOPE'];
  static final String? _grantType = dotenv.env['GRANT_TYPE'];

  factory AuthService() {
    return _singleton;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<bool> fetchToken() async {
    final http.Client client = http.Client();
    
    try {
      final response = await client.post(
        Uri.parse(_authUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'scope': _scope,
          'grant_type': _grantType,
        },
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['access_token'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('access_token', token);
        print('Token fetched successfully');
        return true;
      } else {
        print('Failed to fetch token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception during token fetch: $e');
      return false;
    } finally {
      client.close();
    }
  }
}
