import 'dart:io';
import 'package:tension_node_tools/extensions/xml_element_extension.dart';
import 'package:tension_node_tools/generators/base_generator.dart';
import 'package:tension_node_tools/json/json_match.dart';
import 'package:tension_node_tools/json/json_resources.dart';
import 'package:xml/xml.dart';

class MatchGenerator extends BaseGenerator {
  const MatchGenerator() : super('matches');

  void run() {
    final List<FileSystemEntity> entries = getFiles();

    for (final FileSystemEntity entry in entries) {
      final XmlDocument xml = document(entry);
      final JsonMatch level = getMatch(xml);
      write(entry, level);
    }
  }

  JsonMatch getMatch(XmlDocument document) {
    final XmlElement svg = document.getElement('svg')!;
    final num resourcesRed = svg.getNumAttribute('resourcesRed');
    final num resourcesGreen = svg.getNumAttribute('resourcesGreen');
    final num resourcesBlue = svg.getNumAttribute('resourcesBlue');

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

    return JsonMatch(
      version: 13,
      id: 'foo',
      resources: JsonResources(
        red: resourcesRed,
        green: resourcesGreen,
        blue: resourcesBlue,
      ),
      patches: [],
      nodes: [],
    );
  }
}
