import 'dart:io';
import 'package:tension_node_tools/extensions/xml_element_extension.dart';
import 'package:tension_node_tools/generators/base_generator.dart';
import 'package:tension_node_tools/json/json_match.dart';
import 'package:tension_node_tools/json/json_patch.dart';
import 'package:tension_node_tools/json/json_resources.dart';
import 'package:tension_node_tools/types/resource_type.dart';
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
    final String id = svg.getAttribute('id')!;
    final num version = svg.getNumAttribute('matchVersion');
    final num resourcesRed = svg.getNumAttribute('resourcesRed');
    final num resourcesGreen = svg.getNumAttribute('resourcesGreen');
    final num resourcesBlue = svg.getNumAttribute('resourcesBlue');

    final List<JsonPatch> patches = [];
    final Iterable<XmlElement> layers = document.findAllElements('g');

    for (final XmlElement layer in layers) {
      final String id = layer.getAttribute('id')!;

      if (id == 'patches') {
        patches.addAll(getPatches(layer));
      }
    }

    return JsonMatch(
      version: version,
      id: id,
      resources: JsonResources(
        red: resourcesRed,
        green: resourcesGreen,
        blue: resourcesBlue,
      ),
      patches: patches,
      nodes: [],
    );
  }

  List<JsonPatch> getPatches(XmlElement xml) {
    final List<JsonPatch> result = [];

    for (final XmlElement element in xml.childElements) {
      result.add(getPatch(element));
    }

    return result;
  }

  JsonPatch getPatch(XmlElement element) {
    final ResourceType resource = element.getEnumAttribute(
      'resource',
      ResourceType.values,
    )!;
    final num x = element.getNumAttribute('x');
    final num y = element.getNumAttribute('y');

    return JsonPatch(
      resource: resource,
      position: [x, y],
    );
  }
}
