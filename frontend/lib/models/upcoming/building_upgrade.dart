import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/upcoming/upcoming.dart';
import 'package:godluckwiththat/types/upcoming_type.dart';

class BuildingUpgradeUpcoming extends Upcoming {
  BuildingUpgradeUpcoming({required super.remainingTime})
      : super(upcomingType: UpcomingType.building_upgrade);

  @override
  String get summary => 'Building upgrade completed';

  @override
  IconData get icon => Icons.warehouse;
}
