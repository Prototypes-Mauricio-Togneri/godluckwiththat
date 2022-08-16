import 'package:flutter/rendering.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/types/menu_type.dart';

class MenuInfo {
  final MenuType type;
  final Node? node;
  final Offset realPosition;
  final Offset gamePosition;

  MenuInfo._({
    required this.type,
    required this.node,
    required this.realPosition,
    required this.gamePosition,
  });

  factory MenuInfo.node({
    required Node node,
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.node,
        node: node,
        realPosition: realPosition,
        gamePosition: gamePosition,
      );

  factory MenuInfo.empty({
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.empty,
        node: null,
        realPosition: realPosition,
        gamePosition: gamePosition,
      );

  factory MenuInfo.build({
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.build,
        node: null,
        realPosition: realPosition,
        gamePosition: gamePosition,
      );

  factory MenuInfo.destroy({
    required Node node,
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.destroy,
        node: node,
        realPosition: realPosition,
        gamePosition: gamePosition,
      );
}
