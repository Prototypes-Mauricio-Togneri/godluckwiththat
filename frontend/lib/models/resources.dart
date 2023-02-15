import 'package:tensionnode/json/json_resources.dart';
import 'package:tensionnode/types/resource_type.dart';

class Resources {
  int timber = 0;
  int stone = 0;
  int wood = 0;

  Resources({
    this.timber = 0,
    this.stone = 0,
    this.wood = 0,
  });

  factory Resources.empty() => Resources();

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

  void remove(Resources resources) {
    timber -= resources.timber;
    stone -= resources.stone;
    wood -= resources.wood;
  }

  bool has(Resources resources) =>
      (timber >= resources.timber) &&
      (stone >= resources.stone) &&
      (wood >= resources.wood);

  JsonResources get json => JsonResources(
        timber: timber,
        stone: stone,
        wood: wood,
      );
}
