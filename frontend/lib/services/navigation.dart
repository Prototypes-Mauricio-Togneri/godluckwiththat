import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/services/locator.dart';

class Navigation {
  final Routes routes = Routes();

  static Navigation get get => locator<Navigation>();

  static void pop<T>([T? result]) => get.routes.pop();

  static void dialog(Widget widget) => get.routes.push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, _, __) => widget,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
}
