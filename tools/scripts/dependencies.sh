#!/usr/bin/env bash

set -e

flutter pub upgrade
flutter pub pub run dapublock:dapublock.dart .
flutter pub outdated