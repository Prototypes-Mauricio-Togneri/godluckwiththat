import 'dart:io';
import 'package:tension_node_tools/generators/base_generator.dart';
import 'package:tension_node_tools/json/json_match.dart';
import 'package:tension_node_tools/json/json_resources.dart';
import 'package:xml/xml.dart';

class MatchGenerator extends BaseGenerator {
  const MatchGenerator() : super('matches');

  void run() {
    final List<FileSystemEntity> entries = getFiles();

    for (final FileSystemEntity entry in entries) {
      //final String fileName = entry.uri.pathSegments.last.split('.')[0];

      final XmlDocument xml = document(entry);
      final JsonMatch level = getMatch(xml);
      write(entry, level);
    }
  }

  JsonMatch getMatch(XmlDocument document) {
    /*final List<JsonGameObject> enemies = [];
    final List<JsonGameObject> portal = [];
    final List<JsonGameObject> spikes = [];
    final List<JsonGameObject> powerUps = [];
    final List<JsonGameObject> coins = [];
    final List<JsonGameText> texts = [];
    final List<JsonStars> stars = [];
    final Iterable<XmlElement> layers = document.findAllElements('g');

    for (final XmlElement layer in layers) {
      final String id = layer.getAttribute('id')!;

      if (id == 'enemies') {
        enemies.addAll(getGameObjects(layer));
      } else if (id == 'powerups') {
        powerUps.addAll(getGameObjects(layer));
      } else if (id == 'portal') {
        portal.addAll(getGameObjects(layer));
      } else if (id == 'spikes') {
        spikes.addAll(getGameObjects(layer));
      } else if (id == 'coins') {
        coins.addAll(getGameObjects(layer));
      } else if (id == 'texts') {
        texts.addAll(getGameTexts(layer));
      } else if (id == 'stars') {
        stars.addAll(getStars(layer));
      }
    }*/

    return const JsonMatch(
      version: 13,
      id: 'foo',
      resources: JsonResources(red: 10, green: 20, blue: 30),
      patches: [],
      nodes: [],
    );
  }
}
