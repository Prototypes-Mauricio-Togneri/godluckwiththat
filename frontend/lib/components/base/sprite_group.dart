import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/sprite.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/models/location.dart';

class SpriteGroup extends Component {
  final String sprite;
  SpriteBatchComponent? component;

  SpriteGroup(this.sprite);

  Future setup() async {
    final SpriteBatch spriteBatch = await SpriteBatch.load(sprite);
    component = SpriteBatchComponent(spriteBatch: spriteBatch);
    add(component!);
  }

  Future load(Locations locations) async {
    if (component == null) {
      await setup();
    }

    component!.spriteBatch!.clear();
    final int width = component!.spriteBatch!.width;
    final int height = component!.spriteBatch!.height;

    for (final Location location in locations) {
      component!.spriteBatch!.add(
        source: Rect.fromLTWH(
          0,
          0,
          width.toDouble(),
          height.toDouble(),
        ),
        offset: location.position,
        anchor: Vector2(
          width / 2,
          height / 2,
        ),
        scale: Constants.NODE_SIZE / width,
      );
    }
  }
}
