#!/usr/bin/env bash

set -e

BASE_DIR=`dirname $0`

FORMAT="json"
TOKEN="c1005150-df8b-40a6-97bb-0308fd7a8431"
URL="https://script.google.com/macros/s/AKfycbwU18OiJD0ZEzY__HHHAfA7DrfKXtt1GR2hoYHiuICX52K4dWw0Z0DaRypNS0mnsLnUng/exec"

wget -O "${BASE_DIR}/../assets/i18n/en.json" "${URL}?locale=en&format=${FORMAT}&token=${TOKEN}"
wget -O "${BASE_DIR}/../assets/i18n/es.json" "${URL}?locale=es&format=${FORMAT}&token=${TOKEN}"

flutter pub upgrade
flutter pub pub run dalocale:dalocale.dart ./assets/i18n/ ./lib/utils/localizations.dart en ./lib
dart format lib