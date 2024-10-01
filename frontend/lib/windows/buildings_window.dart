import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/windows/base_window.dart';

class BuildingsWindow extends StatelessWidget {
  const BuildingsWindow();

  static DialogController show() {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => const BuildingsWindow(),
    );

    return DialogController(context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWindow(
      title: 'Buildings',
      child: Container(
        color: Colors.red,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Row1'),
            Text('Row2'),
            Text('Row3'),
            Text('Row4'),
            Text('Row5'),
            Text('Row6'),
            Text('Row7'),
            Text('Row8'),
            Text('Row9'),
          ],
        ),
      ),
    );
  }
}
