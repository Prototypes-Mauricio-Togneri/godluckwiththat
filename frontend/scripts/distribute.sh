#!/usr/bin/env bash

set -e

# ./gradlew appDistributionLogin
export FIREBASE_TOKEN="1//09FKoZoUzpTV-CgYIARAAGAkSNwF-L9IrrhNtzM9Lv85UHRJISE4T5_rdHOmakpd2dayyahCXsl0abSs7MjvOFlleSgKETWHdNyM"

flutter clean
flutter pub get
flutter build apk -t lib/main/main.dart

cd android
./gradlew appDistributionUploadRelease