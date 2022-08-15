import 'package:flutter/widgets.dart';
import 'package:tensionnode/model/game_map.dart';

extension OffsetExtension on Offset {
  Offset nodePosition({required GameMap map}) {
    final int x = (dx / map.blockSize).round();
    final int y = (dy / map.blockSize).round();

    return Offset(x - (map.dimensions.width / 2), y - (map.dimensions.height / 2));
  }
}
