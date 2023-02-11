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

generate tiles_terrain 24 8

generate mine_base 256 256
generate mine_red_blur 395 395
generate mine_green_blur 395 395
generate mine_blue_blur 395 395

generate kernel_base 256 256
generate kernel_blur 445 445

generate turret_light_base 256 256
generate turret_light_blur 395 395

generate turret_heavy_base 256 256
generate turret_heavy_blur 395 395

generate turret_machine_gun_base 256 256
generate turret_machine_gun_blur 395 395

generate enemy_1_base 256 256
generate enemy_1_blur 400 400

generate enemy_2_base 307 307
generate enemy_2_blur 482 482

generate enemy_3_base 358 358
generate enemy_3_blur 564 564

generate ammo_1_base 8 8
generate ammo_1_blur 18 18

generate ammo_2_base 5 15
generate ammo_2_blur 19 29

generate node_selected 358 358