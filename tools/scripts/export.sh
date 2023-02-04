#!/usr/bin/env bash

set -e

BASE_DIR=`dirname $0`
INPUT="${BASE_DIR}/../input/images"
OUTPUT="${BASE_DIR}/../output/images"

rm -r ${OUTPUT}/*

generate () {
    inkscape --export-type="png" --export-filename="${OUTPUT}/${1}.png" --export-area-drawing --export-width=$2 --export-height=$3 ${INPUT}/${1}.svg
}

generate patch_red_base 256 256
generate patch_red_blur 295 295
generate patch_green_base 256 256
generate patch_green_blur 295 295
generate patch_blue_base 256 256
generate patch_blue_blur 295 295

generate mine_base 256 256
generate mine_red_blur 395 395
generate mine_green_blur 395 395
generate mine_blue_blur 395 395

generate kernel_base 256 256
generate kernel_blur 445 445

generate turret_light_base 256 256
generate turret_light_blur 395 395

generate enemy_base 256 256
generate enemy_blur 400 400

generate bullet_base 8 8
generate bullet_blur 12 12

generate laser_base 5 15
generate laser_blur 11 22

generate node_selected 358 358