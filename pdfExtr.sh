#!/bin/bash

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

for pdf in "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
do
    pdf=$(trim $pdf)
    extr=$(zenity --entry --title="Extract from pdf" --text="Specify pages to extract" --entry-text "1-end")
        
    out=$(pdftk A=$pdf cat A$extr output temp.pdf 2>&1)
    if [ $? -ne 0 ] ;
    then
        zenity --notification --text "$out"
        exit 1
    fi
done