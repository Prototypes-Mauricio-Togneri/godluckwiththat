import 'package:tensionplanet/platform/platform_none.dart'
    if (dart.library.html) 'package:tensionplanet/platform/platform_web.dart';

class PlatformInitializer {
  static void init() {
    final PlatformMethods platformMethods = PlatformMethods();
    platformMethods.disableContextualMenu();
    platformMethods.updateUrlStrategy();
  }
}
