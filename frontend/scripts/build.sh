#!/usr/bin/env bash

set -e

flutter clean
flutter build web -t lib/main/main.dart --web-renderer canvaskit --release

OUTPUT="../website/public"
rm -r ${OUTPUT}
mkdir ${OUTPUT}
cp -r build/web/** ${OUTPUT}
cp -r "${OUTPUT}/assets/assets/audio" "${OUTPUT}/assets/"
cp -r "${OUTPUT}/assets/assets/images" "${OUTPUT}/assets/"

cd ../website
firebase deploy --only hosting
cd ../frontend