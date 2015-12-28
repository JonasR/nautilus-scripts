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
    duration=$(zenity --entry --title="WebM length" --text="How many seconds duration" --entry-text "1")
    size=$(zenity --entry --title="Size" --text="How many pixels size?" --entry-text "640")
    
    out=$(ffmpeg -y -i "$videofile" -ss $startseconds -t $duration -c:v libvpx -crf 4 -b:v 1500K -vf scale=$size:-1 -an output.webm 2>&1)
    if [ $? -ne 0 ] ;
    then
        zenity --notification --text "$out"
        exit 1
    fi
done
