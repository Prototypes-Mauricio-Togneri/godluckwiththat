import 'package:tensionplanet/platform/platform_none.dart'
    if (dart.library.html) 'package:tensionplanet/platform/platform_web.dart';

class ClipboardText {
  void copy(String text) => PlatformMethods().clipboard(text);
}
