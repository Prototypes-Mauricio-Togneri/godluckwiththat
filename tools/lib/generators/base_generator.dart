import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart';

class BaseGenerator {
  final String folder;

  const BaseGenerator(this.folder);

  List<FileSystemEntity> getFiles() {
    final Directory dir = Directory('input/$folder');
    return dir.listSync();
  }

  XmlDocument document(FileSystemEntity entry) {
    final File file = File(entry.path);
    return XmlDocument.parse(file.readAsStringSync());
  }

  void write(FileSystemEntity entry, Object object) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String json = encoder.convert(object);

    writeJson(entry, json);
  }

  void writeJson(FileSystemEntity entry, String json) {
    final String fileName = entry.uri.pathSegments.last.split('.')[0];
    final File output = File('output/$folder/$fileName.json');
    output.writeAsStringSync(json);
  }
}
