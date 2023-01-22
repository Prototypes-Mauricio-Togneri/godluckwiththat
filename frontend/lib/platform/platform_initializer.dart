import 'package:tensionnode/platform/platform_none.dart'
    if (dart.library.html) 'package:tensionnode/platform/platform_web.dart';

class PlatformInitializer {
  static void init() => PlatformMethods().disableContextualMenu();
}
