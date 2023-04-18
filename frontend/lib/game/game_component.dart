import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/components/backgrounds/village_background.dart';
import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/components/buildings/farm.dart';
import 'package:tensionplanet/components/buildings/headquarters.dart';
import 'package:tensionplanet/extensions/component_extension.dart';
import 'package:tensionplanet/extensions/logical_keyboard_key_extension.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/producer_location.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/style.dart';

class GameComponent extends FlameGame
    with HasTappables, KeyboardEvents, MouseMovementDetector {
  final GameState state;
  final Component layerSprites = Component(priority: 0);
  final Component layerDebug = Component(priority: 3)
    ..positionType = PositionType.viewport;
  bool clickHandled = false;
  late final Vector2 viewPortSize;

  GameComponent(this.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    /*final VillageBackground villageBackground = VillageBackground(
      image: Assets.IMAGES_BACKGROUNDS_VILLAGE,
      size: viewPortSize,
    );
    addComponent(villageBackground);

    final Building headquarters = Headquarters(level: 1);
    addComponent(headquarters);

    final Building house = House(level: 1);
    addComponent(house);

    final Building warehouse = Warehouse(level: 1);
    addComponent(warehouse);

    final Building market = Market(level: 1);
    addComponent(market);

    final Building fortress = Fortress(level: 1);
    addComponent(fortress);

    final Building farm = Farm(
      level: 1,
      productionTime: 3,
      location: ProducerLocation.north,
    );
    addComponent(farm);

    final Building woodcutter = Woodcutter(
      level: 1,
      productionTime: 5,
      location: ProducerLocation.east,
    );
    addComponent(woodcutter);

    final Building quarry = Quarry(
      level: 1,
      productionTime: 10,
      location: ProducerLocation.west,
    );
    addComponent(quarry);

    final Building copperMine = CopperMine(
      level: 1,
      productionTime: 15,
      location: ProducerLocation.south,
    );
    addComponent(copperMine);

    final Building barracks = Barracks(level: 1);
    addComponent(barracks);

    final Building archery = Archery(level: 1);
    addComponent(archery);

    final Building cavalry = Cavalry(level: 1);
    addComponent(cavalry);

    final Building workshop = Workshop(level: 1);
    addComponent(workshop);*/

    final Inventory inventory = Inventory.empty();
    inventory.addResource(const Resource(ResourceType.food, 300));
    inventory.addResource(const Resource(ResourceType.wood, 100));
    inventory.addResource(const Resource(ResourceType.stone, 0));
    inventory.addResource(const Resource(ResourceType.copper, 0));
    inventory.addResource(const Resource(ResourceType.iron, 0));
    inventory.addResource(const Resource(ResourceType.gold, 0));
    inventory.addResource(const Resource(ResourceType.villager, 10));

    final Village village = Village(
      name: 'Home village',
      inventory: inventory,
      buildings: [],
    );
    village.addBuildings([
      Headquarters(
        village: village,
        level: 1,
      ),
      Farm(
        village: village,
        level: 1,
        productionTime: 3,
        location: ProducerLocation.east,
      ),
    ]);

    state.addVillages([village]);

    loadVillage(state.currentVillage);

    state.setLoaded();

    return super.onLoad();
  }

  void loadVillage(Village village) {
    layerSprites.removeAllComponents();

    final VillageBackground villageBackground = VillageBackground(
      image: Assets.IMAGES_BACKGROUNDS_VILLAGE,
      size: viewPortSize,
    );
    addComponent(villageBackground);

    for (final Building building in village.buildings) {
      addComponent(building);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    state.update(dt);
  }

  Future addBaseComponents(JsonMatch jsonMatch) async {
    viewPortSize = Vector2(
      (size.x / size.y) * Constants.VIEWPORT_SIZE,
      Constants.VIEWPORT_SIZE,
    );
    camera.viewport = FixedResolutionViewport(viewPortSize);

    layerDebug.add(FpsTextComponent(
      position: Vector2(
        size.x - 20,
        size.y - 20,
      ),
      anchor: Anchor.centerRight,
      textRenderer: Style.textRenderer(size: 20),
    ));

    add(layerSprites);
    add(layerDebug);
  }

  @override
  Color backgroundColor() => Palette.black;

  void addComponent(Component component) {
    layerSprites.add(component);
  }

  void removeComponent(Component component) {
    layerSprites.remove(component);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (!clickHandled) {
      // TODO(momo): handle
    }

    clickHandled = false;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final bool isKeyDown = event is RawKeyDownEvent;

    if (keysPressed.isEscape && isKeyDown) {
      // TODO(momo): open main menu
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  void onOpenMainMenu() {}

  void onOpenConstructionMenu() {}

  void onOpenResearchMenu() {}

  void onOpenMilitaryMenu() {}

  void onOpenMap() {}

  void onOpenReportsMenu() {}

  void onOpenVillagesOverviewMenu() {}

  void onOpenExpeditionsMenu() {}
}
