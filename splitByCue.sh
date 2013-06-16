#!/bin/bash

trim() {
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

#TODO: find a solution which also writes stderr to the logfile, since this is where most of shnsplit's interesting info goes
#Note that tee will overwrite $? and comamnd substitution will reset pipestatus
#And this wont work because we already need the variable for something else: http://stackoverflow.com/questions/4410201/pipe-status-after-command-substitution

for cuesheet in "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
do
    cuesheet=$(trim $cuesheet)
    rawFile=$(grep --only-matching -P 'FILE\s+\".+\"\s' "$cuesheet" | cut --delimiter=\" -f 2)

    cbpErr=$(cuebreakpoints "$cuesheet" | shnsplit -o flac "$rawFile" 2>&1 1>>"${cuesheet}.splitlog")
    if [ ${PIPESTATUS[0]} -ne 0 ] ;
    then
        zenity --notification --text "Error while calling cuebreakpoints and shnsplit, exiting.$cbpErr"
        exit 1
    fi
    
    #Apply tags
    ctErr=$(cuetag "$cuesheet" split-track*.flac 2>&1 1>>"${cuesheet}.splitlog")
    if [ $? -ne 0 ] ;
    then
        zenity --notification --text "Error while calling cuetag, exiting.\n$ctErr"
        exit 1
    fi
    echo "Splitting and tagging complete." 1>>"${cuesheet}.splitlog"
done