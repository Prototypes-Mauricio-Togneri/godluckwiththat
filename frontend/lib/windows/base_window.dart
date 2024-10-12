import 'package:flutter/material.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class BaseWindow extends StatelessWidget {
  final String title;
  final GameState state;
  final Widget child;

  const BaseWindow({
    required this.title,
    required this.state,
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
          color: Palette.backgroundWindowTabSelected,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Header(
                state: state,
                title: title,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final GameState state;
  final String title;

  const Header({
    required this.state,
    required this.title,
  });

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
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Palette.backgroundClose,
              child: InkWell(
                onTap: state.closeWindow,
                child: const Padding(
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
