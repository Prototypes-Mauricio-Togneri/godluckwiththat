import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/rendering.dart';
import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/extensions/component_extension.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/models/map_tile.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class BuildingIndicator extends SpriteComponent with HasGameRef<GameComponent> {
  final NodeType nodeType;
  final ResourceType? resourceType;
  bool decoratorAdded = false;

  static const Color DISABLED_COLOR = Color(0x44ff0000);
  static const Color ENABLED_COLOR = Color(0x4400ff00);

  BuildingIndicator({
    required this.nodeType,
    this.resourceType,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(nodeType.sprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.hasMousePosition) {
      position = game.mousePosition;
    }

    final Location location = game.toGridPosition(position);
    final Node? node = game.layerNodes.getNode(location);

    if (node != null) {
      _setDecorator(DISABLED_COLOR);
    } else {
      final MapTile tile = game.getTile(location);
      final Patch? patch = game.state.patches.patchAt(location);
      final bool canBeBuilt = game.nodeCanBeBuilt(
        nodeType: nodeType,
        tile: tile,
        patch: patch,
      );

      if (canBeBuilt) {
        _setDecorator(ENABLED_COLOR);
      } else {
        _setDecorator(DISABLED_COLOR);
      }
    }

    decoratorAdded = true;

    super.update(dt);
  }

  void _setDecorator(Color color) {
    if (decoratorAdded) {
      decorator.replaceLast(PaintDecorator.tint(color));
    } else {
      decorator.addLast(PaintDecorator.tint(color));
    }
  }
}
