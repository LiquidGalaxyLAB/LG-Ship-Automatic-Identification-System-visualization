import 'package:shared_preferences/shared_preferences.dart';

class AisConnectionModel {
  AisConnectionModel._internal({
    required this.clientId,
    required this.clientSecret,
  });

  static final AisConnectionModel _singleton = AisConnectionModel._internal(
    clientId: "",
    clientSecret: "",
  );

  String clientId;
  String clientSecret;

  factory AisConnectionModel() {
    return _singleton;
  }

  Future<bool> isPresentInSharedPreferences(SharedPreferences prefs) async {
    final clientIdPref = prefs.getString('clientId');
    final clientSecretPref = prefs.getString('clientSecret');

    if (clientIdPref != null &&
        clientSecretPref != null) {
      _singleton.clientId = clientIdPref;
      _singleton.clientSecret = clientSecretPref;
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveToSharedPreferences(SharedPreferences prefs) async {
    await prefs.setString('clientId', clientId);
    await prefs.setString('clientSecret', clientSecret);
  }

  Future<void> deleteFromSharedPreferences(SharedPreferences prefs) async {
    await prefs.remove('clientId');
    await prefs.remove('clientSecret');
  }
}