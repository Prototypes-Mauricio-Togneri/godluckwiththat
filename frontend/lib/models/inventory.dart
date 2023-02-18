import 'package:tensionnode/json/json_inventory.dart';
import 'package:tensionnode/services/json.dart';
import 'package:tensionnode/types/resource_type.dart';

class Inventory {
  int timber = 0;
  int stone = 0;
  int wood = 0;

  Inventory({
    this.timber = 0,
    this.stone = 0,
    this.wood = 0,
  });

  factory Inventory.empty() => Inventory();

  bool get isEmpty => (timber == 0) && (stone == 0) && (wood == 0);

  void set({
    int? timber,
    int? stone,
    int? wood,
  }) {
    this.timber = timber ?? this.timber;
    this.stone = stone ?? this.stone;
    this.wood = wood ?? this.wood;
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
    }
  }

  void remove(Inventory inventory) {
    timber -= inventory.timber;
    stone -= inventory.stone;
    wood -= inventory.wood;
  }

  bool has(Inventory resources) =>
      (timber >= resources.timber) &&
      (stone >= resources.stone) &&
      (wood >= resources.wood);

  JsonInventory get json => JsonInventory(
        timber: timber,
        stone: stone,
        wood: wood,
      );

  @override
  String toString() => Json.encode(json.toJson());
}
