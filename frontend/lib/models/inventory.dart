import 'package:tensionnode/json/json_inventory.dart';
import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

class Inventory {
  int timber = 0;
  int stone = 0;
  int wood = 0;
  int water = 0;
  int fish = 0;
  int meat = 0;

  Inventory({
    this.timber = 0,
    this.stone = 0,
    this.wood = 0,
    this.water = 0,
    this.fish = 0,
    this.meat = 0,
  });

  factory Inventory.empty() => Inventory();

  bool get isEmpty =>
      (timber == 0) &&
      (stone == 0) &&
      (wood == 0) &&
      (water == 0) &&
      (fish == 0) &&
      (meat == 0);

  void set({
    int? timber,
    int? stone,
    int? wood,
    int? water,
    int? fish,
    int? meat,
  }) {
    this.timber = timber ?? this.timber;
    this.stone = stone ?? this.stone;
    this.wood = wood ?? this.wood;
    this.water = water ?? this.water;
    this.fish = fish ?? this.fish;
    this.meat = meat ?? this.meat;
  }

  void add(ResourceType type) {
    switch (type) {
      case ResourceType.timber:
        timber++;
        break;
      case ResourceType.stone:
        stone++;
        break;
      case ResourceType.wood:
        wood++;
        break;
      case ResourceType.water:
        water++;
        break;
      case ResourceType.fish:
        fish++;
        break;
      case ResourceType.meat:
        meat++;
        break;
    }
  }

  void remove(Inventory inventory) {
    timber -= inventory.timber;
    stone -= inventory.stone;
    wood -= inventory.wood;
    water -= inventory.water;
    fish -= inventory.fish;
    meat -= inventory.meat;
  }

  bool has(Inventory resources) =>
      (timber >= resources.timber) &&
      (stone >= resources.stone) &&
      (wood >= resources.wood) &&
      (water >= resources.water) &&
      (fish >= resources.fish) &&
      (meat >= resources.meat);

  JsonInventory get json => JsonInventory(
        timber: timber,
        stone: stone,
        wood: wood,
        water: water,
        fish: fish,
        meat: meat,
      );

  @override
  String toString() => Json.encode(json.toJson());
}
