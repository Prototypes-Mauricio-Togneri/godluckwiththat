import 'package:gatewayguardians/platform/platform_none.dart'
    if (dart.library.html) 'package:gatewayguardians/platform/platform_web.dart';

class PlatformInitializer {
  static void init() {
    final PlatformMethods platformMethods = PlatformMethods();
    platformMethods.disableContextualMenu();
    platformMethods.updateUrlStrategy();
  }
}
