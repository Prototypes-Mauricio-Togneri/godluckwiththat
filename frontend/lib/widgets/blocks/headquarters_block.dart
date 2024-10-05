import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class HeadquartersBlock extends StatelessWidget {
  final Headquarters townCenter;

  const HeadquartersBlock(this.townCenter);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Label(text: townCenter.buildingType.name),
    );
  }
}
