import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gatewayguardians/app/gateway_guardians.dart';
import 'package:gatewayguardians/utils/crash_reporter.dart';
import 'package:gatewayguardians/utils/locator.dart';

Future main() async {
  runZonedGuarded(() async {
    await Locator.load();
    runApp(const GatewayGuardians());
  }, CrashReporter.onError);
}
