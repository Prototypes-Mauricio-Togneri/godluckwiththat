import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tensionplanet/app/tension_planet.dart';
import 'package:tensionplanet/utils/crash_reporter.dart';
import 'package:tensionplanet/utils/locator.dart';

Future main() async {
  runZonedGuarded(() async {
    await Locator.load();
    runApp(const TensionPlanet());
  }, CrashReporter.onError);
}
