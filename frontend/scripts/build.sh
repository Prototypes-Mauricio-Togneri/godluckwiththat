#!/usr/bin/env bash

set -e
z
flutter clean
flutter build web -t lib/main/main.dart --web-renderer=canvaskit --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false

OUTPUT="../website/public"
rm -r ${OUTPUT}
mkdir ${OUTPUT}
cp -r build/web/** ${OUTPUT}

cd ../website
firebase deploy --only hosting
cd ../frontend