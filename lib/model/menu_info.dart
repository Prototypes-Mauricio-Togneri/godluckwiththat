import 'package:flutter/rendering.dart';
import 'package:tensionnode/model/nodes/node.dart';

class MenuInfo {
  final Node? node;
  final Offset realPosition;
  final Offset gamePosition;

  MenuInfo({
    required this.node,
    required this.realPosition,
    required this.gamePosition,
  });

  bool get hasNode => node != null;
}
