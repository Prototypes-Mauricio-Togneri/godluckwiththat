import 'dart:async';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/app/god_luck_with_that.dart';
import 'package:godluckwiththat/utils/crash_reporter.dart';
import 'package:godluckwiththat/utils/locator.dart';

Future main() async {
  runZonedGuarded(() async {
    await Locator.load();
    runApp(const GodLuckWithThat());
  }, CrashReporter.onError);
}
