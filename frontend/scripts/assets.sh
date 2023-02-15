#!/usr/bin/env bash

set -e

#INPUT="../tools/output/images"
#OUTPUT="./assets"
#../tools/scripts/export.sh
#rm -r ${OUTPUT}/images/*
#cp -a ${INPUT} ${OUTPUT}
#cp "${INPUT}/../../input/map/terrain.tsx" "${OUTPUT}/tiles"

flutter clean
flutter pub upgrade
flutter pub pub run daassets:daassets.dart ./pubspec.yaml ./lib/services/assets.dart
sed -i'.original' -e 's/\.\/assets/assets/' "./lib/services/assets.dart"
sed -i'.original' -e 's/assets\/images\///' "./lib/services/assets.dart"
sed -i'.original' -e 's/assets\/audio\///' "./lib/services/assets.dart"
sed -i'.original' -e 's/assets\/tiles\///' "./lib/services/assets.dart"
rm "./lib/services/assets.dart.original"
dart format lib