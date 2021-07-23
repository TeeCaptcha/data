#!/bin/bash

function crop() {
	# based on crop.sh by Vitor
	# https://superuser.com/a/885830
	if [ "$#" != "5" ]
	then
		echo "usage:"
		tput bold
		echo "  $(basename "$0") <tileset_image_file> <tileset_image_width> <tileset_image_height> <tile_size_X> <tile_size_y>"
		tput sgr0
		echo ""
		echo "example:"
		tput bold
		echo "  $(basename "$0") tileset01.png 128 192 32 32"
		tput sgr0
		echo ""
		echo "    Will generate 24 tiles of 32x32 named tile1.png, tile2.png, ..., tile24.png"
		exit 1
	fi

	# Your tileset file. I've tested with a png file.
	origin=$1

	counter=0

	tile_size_x="$4"
	tile_size_y="$5"

	rows="$2"
	rows="$((rows/tile_size_x))"

	columns="$3"
	columns="$((columns/tile_size_y))"

	echo "Extracting $((rows * columns)) tiles..."

	for i in $(seq 0 $((columns - 1)))
	do
		for j in $(seq 0 $((rows - 1)))
		do
			# Calculate next cut offset.
			offset_y="$((i * tile_size_y))"
			offset_x="$((j * tile_size_x))"

			# Update naming variable.
			counter="$((counter + 1))"

			tile_name="$j-$i.png"

			convert -extract "${tile_size_x}x${tile_size_y}+${offset_x}+${offset_y}" "$origin" "$tile_name"
		done
	done

	echo "done"
}

if [ "$#" != "2" ]
then
	echo "usage:"
	tput bold
	echo "  $(basename "$0") <image> <destination>"
	tput sgr0
	echo "description:"
	echo "  scales down to 720x405 and chops into pieces"
	echo "example:"
	tput bold
	echo "  $(basename "$0") input.png 0"
	tput sgr0
	exit 1
fi

img="$1"
dst="$2"
rows=4
cols=4

if [ ! -f "$img" ]
then
	echo "Error: image not found '$img'"
	exit 1
fi

mkdir -p "$dst" || exit 1
convert "$img" -scale 720x405 "$dst"/raw_720x405.png || exit 1
cd "$dst" || exit 1
crop raw_720x405.png 720 405 180 101
rm raw_720x405.png

