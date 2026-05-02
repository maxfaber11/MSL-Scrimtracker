import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Exporter {
  static Future<String> saveStringToDownloads(String fileName, String content) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(content);
    return file.path;
  }
}
