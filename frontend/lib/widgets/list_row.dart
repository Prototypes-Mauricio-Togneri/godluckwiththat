import 'package:flutter/widgets.dart';
import 'package:godluckwiththat/utils/palette.dart';

class ListRow extends StatelessWidget {
  final List<Widget> children;

  const ListRow({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Palette.grey,
        border: Border.all(
          width: 2,
          color: Palette.lightGrey,
        ),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}
