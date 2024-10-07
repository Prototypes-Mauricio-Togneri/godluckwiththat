import 'package:flutter/material.dart';
import 'package:godluckwiththat/models/upcoming/upcoming.dart';
import 'package:godluckwiththat/types/upcoming_type.dart';

class AttackUpcoming extends Upcoming {
  AttackUpcoming({required super.remainingTime})
      : super(upcomingType: UpcomingType.attack);

  @override
  String get summary => 'Tribe attack arriving';

  @override
  IconData get icon => Icons.security;
}
