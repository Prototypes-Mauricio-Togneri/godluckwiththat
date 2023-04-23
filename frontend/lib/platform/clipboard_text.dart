import 'package:gatewayguardians/platform/platform_none.dart'
    if (dart.library.html) 'package:gatewayguardians/platform/platform_web.dart';

class ClipboardText {
  void copy(String text) => PlatformMethods().clipboard(text);
}
