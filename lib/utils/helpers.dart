import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<File> createFile(String name, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$name');
    file.writeAsStringSync(content);

    return file;
  }

  Future<File> createImage(String name, String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$name');

    final imageData = await rootBundle.load(imagePath);
    final bytes = imageData.buffer
        .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);

    file.writeAsBytesSync(bytes);

    return file;
  }