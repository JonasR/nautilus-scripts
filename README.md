nautilus-scripts
================

User scripts to be used with the nautilus filemanager

splitByCue.sh
----------------------
Split and tag audio files by a given Cuesheet.

Depends on:

* cuetools
* shntools
* flac
* zenity
* (wavpack, mac/monkeys-audio)

Output files are always in .flac format, because the others suck

[cue2track, A more powerful alternative I didn't know about] (https://code.google.com/p/cue2tracks/downloads/list)

pdfExtr.sh
----------------------
Extract pages from pdf files (I always forget pdftk's syntax...)

Depends on:
* pdftk
* zenity

makeGif.sh
----------------------
Creates a high-quality GIF from an input video file.

Depends on:
* ffmpeg
* zenity

makeWebM.sh
----------------------
Creates a non-audio WebM from an input video file.

Depends on:
* ffmpeg
* zenity
