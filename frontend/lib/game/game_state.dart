import 'package:dafluta/dafluta.dart';
import 'package:tensionplanet/components/buildings/headquarters.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/research.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;

  late final GameComponent gameComponent;
  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Village> villages = [];
  late Village currentVillage;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;
  }

  void initialize(GameComponent value) {
    gameComponent = value;

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
      freeVillagers: 10,
      constructions: [],
    );
    village.addBuildings([
      Headquarters(
        village: village,
        level: 1,
      ),
    ]);

    villages.addAll([village]);
    currentVillage = village;

    gameComponent.loadVillage(currentVillage);

    Delayed.post(() {
      loaded = true;
      notify();
    });
  }

  void update(double dt) {
    totalTimeElapsed += dt;
    refreshTimeout += dt;

    if (totalTimeElapsed == 0) {
      print(totalTimeElapsed);
    }

    if (refreshTimeout > 1) {
      refreshTimeout--;
      notify();
    }

    for (final Village village in villages) {
      village.update(dt);
    }
  }
}
