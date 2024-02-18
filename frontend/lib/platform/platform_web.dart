import 'dart:html';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:godluckwiththat/platform/empty_url_strategy.dart';
import 'package:godluckwiththat/platform/platform_base.dart';

class PlatformMethods extends PlatformMethodsBase {
  @override
  void updateUrlStrategy() => setUrlStrategy(EmptyUrlStrategy());

  @override
  void disableContextualMenu() =>
      window.document.onContextMenu.listen((evt) => evt.preventDefault());
}
