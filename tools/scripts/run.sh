#!/usr/bin/env bash

set -e

echo "AAA"

export PATH="/opt/Flutter/bin:$PATH"

dart lib/tools.dart
cd ../frontend
dart format lib --line-length=150