import 'package:flutter/rendering.dart';
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
}
