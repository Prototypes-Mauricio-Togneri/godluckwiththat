import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/locator.dart';

class Navigation {
  final Routes routes = Routes();

  static Navigation get get => locator<Navigation>();

  static void pop<T>([T? result]) => get.routes.pop();

  static Route<dynamic>? get currentRoute => get.routes.current();

  static bool isCurrent(String name) => currentRoute?.settings.name == name;

  static void dialog({
    required Widget widget,
    required String name,
  }) {
    if (!isCurrent(name)) {
      get.routes.push(
        PageRouteBuilder(
          settings: RouteSettings(name: name),
          opaque: false,
          pageBuilder: (context, _, __) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
  }
}
