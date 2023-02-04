#!/usr/bin/env bash

set -e

INPUT="./input/images"
OUTPUT="./output/images"

rm -r ${OUTPUT}/*

generate () {
    inkscape --export-type="png" --export-filename="${OUTPUT}/${1}.png" --export-area-drawing --export-width=$2 --export-height=$3 ${INPUT}/${1}.svg
}

generate mine_blue_blur 395 395