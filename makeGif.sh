#!/bin/bash

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

for videofile in "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
do
    videofile=$(trim $videofile)
    startseconds=$(zenity --entry --title="Set start offset" --text="How many seconds offset?" --entry-text "0")
    duration=$(zenity --entry --title="Gif length" --text="How many seconds duration" --entry-text "1")
    fps=$(zenity --entry --title="FPS" --text="How many FPS?" --entry-text "6")
    size=$(zenity --entry --title="Size" --text="How many pixels size?" --entry-text "600")

    out=$(ffmpeg -y -ss $startseconds -t $duration -i "$videofile" -vf fps=$fps,scale=$size:-1:flags=lanczos,palettegen palette.png 2>&1)
    if [ $? -ne 0 ] ;
    then
        zenity --notification --text "$out"
        exit 1
    fi
    out=$(ffmpeg -y -ss $startseconds -t $duration -i "$videofile" -i palette.png -filter_complex "fps=$fps,scale=$size:-1:flags=lanczos[x];[x][1:v]paletteuse" "${videofile}.gif" 2>&1)
    if [ $? -ne 0 ] ;
    then
        zenity --notification --text "$out"
        exit 1
    fi
    rm -f palette.png
done
