import 'package:flutter/rendering.dart';
import 'package:tensionnode/engine/renderer.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/model/patch.dart';

class Patches {
  final List<Patch> _patches = [];

  void add(Patch element) => _patches.add(element);

  Patch? at(Offset position) {
    for (final Patch patch in _patches) {
      if (patch.isAt(position)) {
        return patch;
      }
    }

    return null;
  }

  void render(Renderer renderer) {
    for (final Patch patch in _patches) {
      patch.render(renderer);
    }
  }

  List<JsonPatch> get json => _patches.map((patch) => patch.json).toList();
}
