import 'package:flutter/rendering.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/patch.dart';
import 'package:tensionnode/types/menu_type.dart';

class MenuInfo {
  final MenuType type;
  final Node? node;
  final Patch? patch;
  final Offset? realPosition;
  final Offset? gamePosition;

  MenuInfo._({
    required this.type,
    this.node,
    this.patch,
    this.realPosition,
    this.gamePosition,
  });

  bool get hasPatch => patch != null;

  factory MenuInfo.main() => MenuInfo._(type: MenuType.main);

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
    required Patch? patch,
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.empty,
        patch: patch,
        realPosition: realPosition,
        gamePosition: gamePosition,
      );

  factory MenuInfo.build({
    required Patch? patch,
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.build,
        patch: patch,
        realPosition: realPosition,
        gamePosition: gamePosition,
      );

  factory MenuInfo.defense({
    required Offset realPosition,
    required Offset gamePosition,
  }) =>
      MenuInfo._(
        type: MenuType.defense,
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
