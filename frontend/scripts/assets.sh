#!/usr/bin/env bash

set -e

flutter clean
flutter pub upgrade
flutter pub run daassets:daassets.dart ./pubspec.yaml ./lib/utils/assets.dart
#sed -i'.original' -e 's/\.\/assets/assets/' "./lib/utils/assets.dart"
#sed -i'.original' -e 's/assets\/images\///' "./lib/utils/assets.dart"
#sed -i'.original' -e 's/assets\/audio\///' "./lib/utils/assets.dart"
#sed -i'.original' -e 's/assets\/tiles\///' "./lib/utils/assets.dart"
#rm "./lib/utils/assets.dart.original"
dart format lib