import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/widgets/label.dart';

class ItemRow extends StatelessWidget {
  final String sprite;
  final String amount;

  const ItemRow({
    required this.sprite,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Image.asset(
              'images/$sprite',
            ),
          ),
          const HBox(10),
          Label(
            text: amount,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
