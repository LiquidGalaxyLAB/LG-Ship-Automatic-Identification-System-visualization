import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ais_visualizer/models/kml/blank_kml_model.dart';
import 'package:ais_visualizer/models/kml/screen_overlay_kml_model.dart';
import 'package:ais_visualizer/models/lg_connection_model.dart';
import 'package:ais_visualizer/utils/helpers.dart';
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
  bool _isUploading = false;

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

  Future<void> uploadKml(String content, String fileName) async {
    connectToLG();
    if (_isUploading) {
      return;
    }
    _isUploading = true; // Set the flag before starting the upload process

    try {
      print("Uploading KML...");
      final sftp = await _client?.sftp();
      if (sftp == null) {
        throw Exception('Failed to initialize SFTP client');
      }

      // Create and open the file
      final file = await sftp.open('/var/www/html/$fileName',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      // Write the content
      await file.write(Stream.value(const Utf8Encoder().convert(content))).done;
      await file.close();
      await execute('echo "$_url/$fileName" > /var/www/html/kmls.txt',
          'KML file written successfully');
      print('Upload complete!');
    } catch (e) {
      print('Error during KML upload: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<void> uploadKml4(String content, String fileName) async {
    connectToLG();
    if (_isUploading) {
      return;
    }
    _isUploading = true; // Set the flag before starting the upload process

    try {
      print("Uploading KML...");
      final sftp = await _client?.sftp();
      if (sftp == null) {
        throw Exception('Failed to initialize SFTP client');
      }

      final file = await sftp.open(
        '/var/www/html/$fileName',
        mode: SftpFileOpenMode.truncate |
            SftpFileOpenMode.create |
            SftpFileOpenMode.write,
      );

      final currentFile = await createFile(fileName, content);
      final fileStream = currentFile.openRead();
      int offset = 0;

      await for (final chunk in fileStream) {
        final typedChunk = Uint8List.fromList(chunk);
        await file.write(Stream.fromIterable([typedChunk]), offset: offset);
        offset += typedChunk.length;
      }

      print("\n");
      print('file successfully uploaded');
      await execute('echo "$_url/$fileName" > /var/www/html/kmls.txt',
          'KML file written successfully');
      print('Upload complete!');
    } catch (e) {
      print('Error during KML upload: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<void> uploadKml2(String content, String fileName) async {
    if (_isUploading) {
      return;
    }
    _isUploading = true; // Set the flag before starting the upload process

    try {
      print("Uploading KML...");
      final sftp = await _client?.sftp();
      if (sftp == null) {
        throw Exception('Failed to initialize SFTP client');
      }

      // Create and open the file
      final file = await sftp.open('/var/www/html/$fileName',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      // Create a stream from the content
      const chunkSize = 1024; // Adjust chunk size as needed
      final stream = Stream<Uint8List>.fromIterable(
        List.generate(
          (content.length / chunkSize).ceil(),
          (i) {
            final start = i * chunkSize;
            final end = start + chunkSize < content.length
                ? start + chunkSize
                : content.length;
            return Uint8List.fromList(
                utf8.encode(content.substring(start, end)));
          },
        ),
      );

      // Write the stream to the file
      await file.write(stream);
      await file.close();

      await execute('echo "$_url/$fileName" > /var/www/html/kmls.txt',
          'KML file written successfully');
      print('Upload complete!');
    } catch (e) {
      print('Error during KML upload: $e');
    } finally {
      _isUploading = false;
    }
  }

  Future<void> uploadKml3(
      Stream<Uint8List> contentStream, String fileName) async {
    if (_isUploading) {
      return;
    }
    _isUploading = true;

    const int maxRetries = 3;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      bool success =
          await _uploadKmlStream(contentStream, fileName, maxRetries);
      if (success) {
        await execute('echo "$_url/$fileName" > /var/www/html/kmls.txt',
            'KML file written successfully');
        print('Upload complete!');
        _isUploading = false;
        return;
      } else {
        print('Upload attempt $attempt failed. Retrying...');
      }
    }

    print('Failed to upload KML after $maxRetries attempts.');
    _isUploading = false;
  }

  Future<bool> _uploadKmlStream(
      Stream<Uint8List> contentStream, String fileName, int maxRetries) async {
    try {
      print("Uploading KML...");
      final sftp = await _client?.sftp();
      if (sftp == null) {
        throw Exception('Failed to initialize SFTP client');
      }

      final file = await sftp.open('/var/www/html/$fileName',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      StreamController<Uint8List> streamController =
          StreamController<Uint8List>();

      // Add content stream to the controller
      contentStream.listen((chunk) {
        streamController.add(chunk);
      }, onDone: () {
        streamController.close();
      }, onError: (error) {
        streamController.addError(error);
      });

      await for (Uint8List chunk in streamController.stream) {
        bool chunkSuccess = false;

        for (int chunkAttempt = 1; chunkAttempt <= maxRetries; chunkAttempt++) {
          try {
            await file.writeBytes(chunk);
            chunkSuccess = true;
            break;
          } catch (e) {
            if (chunkAttempt == maxRetries) {
              print('Failed to upload chunk after $maxRetries attempts: $e');
              return false;
            } else {
              print('Chunk upload attempt $chunkAttempt failed. Retrying...');
            }
          }
        }

        if (!chunkSuccess) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error during KML upload: $e');
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

  Future<void> startTour(String tourName) async {
    await query('playtour=$tourName');
  }

  Future<void> cleanBeforeTour() async {
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';
    await execute(
        query, 'Liquid Galaxy exited tour and cleared kmls.txt successfully');
  }

  Future<void> stopTour() async {
    await query('exittour=true');
  }

  // refresh every 2 seconds
  Future<bool> setRefresh() async {
    final pw = _lgConnectionModel.password;

    const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
    const replace =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    final command =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    final clear =
        'echo $pw | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

    bool allSuccessful = true;
    for (var i = 2; i <= _lgConnectionModel.screenNumber; i++) {
      final clearCmd = clear.replaceAll('{{slave}}', i.toString());
      final cmd = command.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'{{cmd}}\'';

      final result1 = await execute(query.replaceAll('{{cmd}}', clearCmd), 'Clearing refresh');
      allSuccessful = allSuccessful && (result1 != null);
      final result2 =  await execute(query.replaceAll('{{cmd}}', cmd), 'Setting refresh');
      allSuccessful = allSuccessful && (result2 != null);
    }
    final result = await reboot();
    return allSuccessful && result;
  }

  // stop refreshing
  Future<bool> resetRefresh() async {
    final pw = _lgConnectionModel.password;

    const search =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    const replace = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';

    final clear =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    bool allSuccessful = true;
    for (var i = 2; i <= _lgConnectionModel.screenNumber; i++) {
      final cmd = clear.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'$cmd\'';

      final result = await execute(query, 'Resetting refresh');
      allSuccessful = allSuccessful && (result != null);
    }
    final result = await reboot();
    return result && allSuccessful;
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

  int getScreenNumber() {
    return _lgConnectionModel.screenNumber;
  }
}
