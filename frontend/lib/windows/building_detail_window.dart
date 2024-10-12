import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/windows/base_window.dart';

class BuildingDetailWindow extends StatelessWidget {
  final String title;
  final Widget child;

  const BuildingDetailWindow({
    required this.title,
    required this.child,
  });

  static DialogController show({
    required String title,
    required Widget child,
  }) =>
      BaseWindow.show(BuildingDetailWindow(
        title: title,
        child: child,
      ));

  @override
  Widget build(BuildContext context) {
    return BaseWindow(
      title: title,
      child: Container(
        color: Palette.backgroundWindowTabSelected,
        child: child,
      ),
    );
  }
}
