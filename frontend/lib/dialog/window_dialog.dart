import 'package:flutter/material.dart';
import 'package:gatewayguardians/utils/navigation.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/label.dart';

class WindowDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const WindowDialog({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: Palette.lightGrey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Palette.grey,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 10,
                      left: 12,
                    ),
                    child: Label(
                      text: title,
                      color: Palette.white,
                      size: 12,
                    ),
                  ),
                ),
                const Material(
                  color: Palette.transparent,
                  child: InkWell(
                    onTap: Navigation.pop,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 10,
                        left: 6,
                        right: 6,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Palette.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
