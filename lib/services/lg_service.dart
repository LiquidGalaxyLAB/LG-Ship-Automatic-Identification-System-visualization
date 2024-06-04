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
      final socket = await SSHSocket.connect(_lgConnectionModel.ip, _lgConnectionModel.port);

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
}