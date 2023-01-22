import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';

extension ComponentExtension on Component {
  Future<Sprite> getSprite(String path) async {
    final Image image = await Flame.images.load(path);

    return Sprite(image);
  }
}
