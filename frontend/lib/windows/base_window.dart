import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/navigation.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class BaseWindow extends StatelessWidget {
  final String title;
  final Widget child;

  const BaseWindow({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Palette.transparent,
      contentPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 800,
          maxHeight: MediaQuery.of(context).size.height - 200,
        ),
        child: Container(
          color: Palette.backgroundWindowContent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(title),
              child,
            ],
          ),
        ),
      ),
    );
  }

  static DialogController show(Widget widget) {
    final BuildContext context = Navigation.context;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Palette.transparent,
      builder: (context) => widget,
    );

    return DialogController(context);
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Palette.backgroundWindowHeader,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Label(
              text: title,
              size: 14,
              weight: FontWeight.bold,
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Palette.backgroundClose,
              child: InkWell(
                onTap: Navigation.pop,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.close,
                    color: Palette.iconLevel1,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
