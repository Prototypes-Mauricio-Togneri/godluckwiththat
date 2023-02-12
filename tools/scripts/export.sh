#!/usr/bin/env bash

set -e

BASE_DIR=`dirname $0`
INPUT="${BASE_DIR}/../input/images"
OUTPUT="${BASE_DIR}/../output/images"

rm -r ${OUTPUT}/*

generate () {
    echo ${1}
    inkscape --export-type="png" --export-filename="${OUTPUT}/${1}.png" --export-area-drawing --export-width=$2 --export-height=$3 ${INPUT}/${1}.svg
}

generate tiles_terrain 48 8

generate mine 256 256

generate kernel 256 256

generate turret_light 256 256
generate turret_heavy 256 256
generate turret_machine_gun 256 256

generate enemy 256 256

generate ammo_1 64 64

generate ammo_2 80 240

generate node_selected 358 358

cp "${BASE_DIR}/../output/images/tiles_terrain.png" "${BASE_DIR}/../input/map"