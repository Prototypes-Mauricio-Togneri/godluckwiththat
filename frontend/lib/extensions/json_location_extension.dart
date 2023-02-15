import 'package:tensionnode/models/location.dart';

typedef JsonLocation = List<int>;

extension JsonLocationExtension on JsonLocation {
  Location get location => Location(
        this[0].toInt(),
        this[1].toInt(),
      );
}
