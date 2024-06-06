import 'package:shared_preferences/shared_preferences.dart';

class LgConnectionModel {
  LgConnectionModel._internal({
    required this.ip,
    required this.port,
    required this.userName,
    required this.password,
    required this.screenNumber,
  });

  static final LgConnectionModel _singleton = LgConnectionModel._internal(
    ip: "",
    port: 22,
    userName: "",
    password: "",
    screenNumber: 3,
  );

  String ip;
  int port;
  String userName;
  String password;
  int screenNumber;

  factory LgConnectionModel() {
    return _singleton;
  }

  Future<bool> isPresentInSharedPreferences(SharedPreferences prefs) async {
    final ipPref = prefs.getString('ip');
    final portPref = prefs.getInt('port');
    final userNamePref = prefs.getString('userName');
    final passwordPref = prefs.getString('password');
    final screenNumberPref = prefs.getInt('screenNumber');

    if (ipPref != null &&
        portPref != null &&
        userNamePref != null &&
        passwordPref != null &&
        screenNumberPref != null) {
      _singleton.ip = ipPref;
      _singleton.port = portPref;
      _singleton.userName = userNamePref;
      _singleton.password = passwordPref;
      _singleton.screenNumber = screenNumberPref;
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveToSharedPreferences(SharedPreferences prefs) async {
    await prefs.setString('ip', ip);
    await prefs.setInt('port', port);
    await prefs.setString('userName', userName);
    // **Security Note:** Consider using a secure storage solution for password
    await prefs.setString('password', password);
    await prefs.setInt('screenNumber', screenNumber);
  }

  Future<void> deleteFromSharedPreferences(SharedPreferences prefs) async {
    await prefs.remove('ip');
    await prefs.remove('port');
    await prefs.remove('userName');
    await prefs.remove('password');
    await prefs.remove('screenNumber');
  }
}