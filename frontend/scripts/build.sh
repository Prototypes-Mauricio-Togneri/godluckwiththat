#!/usr/bin/env bash

set -e

flutter clean
flutter build web -t lib/main/main.dart
#--web-renderer=canvaskit --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false

OUTPUT="../website/public"
rm -r ${OUTPUT}
mkdir ${OUTPUT}
cp -r build/web/** ${OUTPUT}
cp -r "${OUTPUT}/assets/assets/audio" "${OUTPUT}/assets/"
cp -r "${OUTPUT}/assets/assets/images" "${OUTPUT}/assets/"
cp -r "${OUTPUT}/assets/assets/tiles" "${OUTPUT}/assets/"

cd ../website
firebase deploy --only hosting
cd ../frontend