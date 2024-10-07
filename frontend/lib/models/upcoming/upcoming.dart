import 'package:flutter/material.dart';
import 'package:godluckwiththat/types/upcoming_type.dart';

abstract class Upcoming {
  final UpcomingType upcomingType;
  num remainingTime;

  Upcoming({
    required this.upcomingType,
    required this.remainingTime,
  });

  bool update(double dt) {
    remainingTime -= dt;

    return remainingTime <= 1;
  }

  String get summary;

  IconData get icon;
}
