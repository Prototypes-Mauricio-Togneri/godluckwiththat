import 'dart:html';
import 'package:tensionnode/platform/platform_base.dart';

class PlatformMethods extends PlatformMethodsBase {
  @override
  void disableContextualMenu() => window.document.onContextMenu.listen((evt) => evt.preventDefault());
}
