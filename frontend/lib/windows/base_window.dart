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
}

class Header extends StatelessWidget {
  final String title;

  const Header(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: Palette.backgroundWindowHeader,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Label(
              text: title,
              size: 15,
              weight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Palette.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Palette.iconLevel1,
                  size: 20,
                ),
                onPressed: Navigation.pop,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
