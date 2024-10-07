import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/upcoming_type.dart';

abstract class Upcoming {
  final UpcomingType upcomingType;
  num remainingTime;

  Upcoming({
    required this.upcomingType,
    required this.remainingTime,
  });

  void update(double dt) {
    remainingTime -= dt;
  }

  String get summary;

  IconData get icon;
}
