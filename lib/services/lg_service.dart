import 'dart:io';
import 'package:ais_visualizer/models/lg_connection_model.dart';
import 'package:dartssh2/dartssh2.dart';

class LgService {
  LgService._internal();
  static final LgService _singletone = LgService._internal();

  factory LgService() {
    return _singletone;
  }

  SSHClient? _client;
  final LgConnectionModel _lgConnectionModel = LgConnectionModel();

  Future<bool?> connectToLG() async {
    try {
      final socket = await SSHSocket.connect(
          _lgConnectionModel.ip, _lgConnectionModel.port);

      _client = SSHClient(
        socket,
        username: _lgConnectionModel.userName,
        onPasswordRequest: () => _lgConnectionModel.password,
      );
      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

  Future<SSHSession?> execute(cmd, successMessage) async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final result = await _client!.execute(cmd);
      print(successMessage);
      return result;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<bool> query(String content) async {
    final result = await execute(
        'echo "$content" > /tmp/query.txt', 'Query sent successfully');
    return result != null;
  }

  Future<bool> shutdown() async {
    bool allSuccessful = true;
    for (int i = 1; i <= _lgConnectionModel.screenNumber; i++) {
      final shutdownCommand =
          'sshpass -p ${_lgConnectionModel.password} ssh -t lg$i "echo ${_lgConnectionModel.password} | sudo -S shutdown now"';
      final result = await execute(shutdownCommand, 'Liquid Galaxy $i shutdown successfully');
      allSuccessful = allSuccessful && (result != null);
    }
    return allSuccessful;
  }

  Future<bool> relaunchLG() async {
    final relaunchCmd = """
        RELAUNCH_CMD="\\
        if [ -f /etc/init/lxdm.conf ]; then
          export SERVICE=lxdm
        elif [ -f /etc/init/lightdm.conf ]; then
          export SERVICE=lightdm
        else
          exit 1
        fi

        if [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
          echo ${_lgConnectionModel.password} | sudo -S service \\\${SERVICE} start
        else
          echo ${_lgConnectionModel.password} | sudo -S service \\\${SERVICE} restart
        fi
        " && sshpass -p ${_lgConnectionModel.password} ssh -x -t lg@lg1 "\$RELAUNCH_CMD\"""";

    final result = await execute(relaunchCmd, 'Liquid Galaxy relaunched successfully');
    return result != null;
  }

  Future<bool> reboot() async {
    bool allSuccessful = true;
    for (int i = 1; i <= _lgConnectionModel.screenNumber; i++) {
      final rebootCommand =
          'sshpass -p ${_lgConnectionModel.password} ssh -t lg$i "echo ${_lgConnectionModel.password} | sudo -S reboot"';
      final result = await execute(rebootCommand, 'Liquid Galaxy $i rebooted successfully');
      allSuccessful = allSuccessful && (result != null);
    }
    return allSuccessful;
  }

  Future<bool> clearKML() async {
    bool allSuccessful = true;
    for (int i = 2; i <= _lgConnectionModel.screenNumber; i++) {
      final clearCommand =
          'echo "" > /var/www/html/kml/slave_$i.kml';
      final result = await execute(clearCommand, 'Liquid Galaxy cleared KML from slave $i successfully');
      allSuccessful = allSuccessful && (result != null);
    }
    return allSuccessful;
  }
}
