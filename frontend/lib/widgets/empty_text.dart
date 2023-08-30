import 'package:flutter/widgets.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/label.dart';

class EmptyText extends StatelessWidget {
  final String text;

  const EmptyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Label(
          text: text,
          color: Palette.lightGrey,
          size: 25,
        ),
      ),
    );
  }
}
