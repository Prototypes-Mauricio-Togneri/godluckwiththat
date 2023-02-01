import 'package:tension_node_tools/types/types.dart';

extension JsonPositionExtension on JsonPosition {
  num get x => this[0];

  num get y => this[1];
}
