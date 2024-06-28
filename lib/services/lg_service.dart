import 'dart:io';
import 'package:ais_visualizer/models/kml/blank_kml_model.dart';
import 'package:ais_visualizer/models/kml/screen_overlay_kml_model.dart';
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
  final String _url = 'http://lg1:81';

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

  uploadKml(File inputFile, String fileName) async {
    print("uploading kml");
    final sftp = await _client?.sftp();
    final file = await sftp?.open('/var/www/html/$fileName',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);
    print('Uploading KML...');
    await file?.write(inputFile.openRead().cast());
    print('Done Upload!');

    await execute('echo "$_url/$fileName" > /var/www/html/kmls.txt',
        'KML uploaded successfully');
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
      final result = await execute(
          shutdownCommand, 'Liquid Galaxy $i shutdown successfully');
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

    final result =
        await execute(relaunchCmd, 'Liquid Galaxy relaunched successfully');
    return result != null;
  }

  Future<bool> reboot() async {
    bool allSuccessful = true;
    for (int i = 1; i <= _lgConnectionModel.screenNumber; i++) {
      final rebootCommand =
          'sshpass -p ${_lgConnectionModel.password} ssh -t lg$i "echo ${_lgConnectionModel.password} | sudo -S reboot"';
      final result = await execute(
          rebootCommand, 'Liquid Galaxy $i rebooted successfully');
      allSuccessful = allSuccessful && (result != null);
    }
    return allSuccessful;
  }

  Future<bool> cleanKMLsAndVisualization(bool keepLogo) async {
    bool allSuccessful = true;

    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';
    final queryResult = await execute(
        query, 'Liquid Galaxy exited tour and cleared kmls.txt successfully');
    allSuccessful = allSuccessful && (queryResult != null);

    for (int i = 2; i <= _lgConnectionModel.screenNumber; i++) {
      String kmlContent = BlankKmlModel.generateBlankKml('slave_$i');
      final clearCommand =
          "echo '$kmlContent' > /var/www/html/kml/slave_$i.kml";
      final result = await execute(
          clearCommand, 'Liquid Galaxy cleared KML from slave $i successfully');
      allSuccessful = allSuccessful && (result != null);
    }
    return allSuccessful;
  }

  Future<bool> sendLogo() async {
    String kmlContent = ScreenOverlayKmlModel.generateLogo();
    int leftMostScreen =
        calculateLeftMostScreen(_lgConnectionModel.screenNumber);

    final result = await execute(
        "echo '$kmlContent' > /var/www/html/kml/slave_$leftMostScreen.kml",
        'Liquid Galaxy logo sent successfully');
    return result != null;
  }

  Future<bool> sendBallonKml(String kmlContent) async {
    int rightMostScreen =
        calculateRightMostScreen(_lgConnectionModel.screenNumber);
    print("in sending kml");
    final result = await execute(
        "echo '$kmlContent' > /var/www/html/kml/slave_$rightMostScreen.kml",
        'Liquid Galaxy KML sent successfully');
    return result != null;
  }

  Future<void> flyTo(String linearTag) async {
    await query('flytoview=$linearTag');
  }

  int calculateLeftMostScreen(int screenNumber) {
    if (screenNumber == 1) {
      return 1;
    } else {
      return (screenNumber / 2).floor() + 2;
    }
  }

  int calculateRightMostScreen(int screenNumber) {
    if (screenNumber == 1) {
      return 1;
    } else {
      return (screenNumber / 2).floor() + 1;
    }
  }
}
