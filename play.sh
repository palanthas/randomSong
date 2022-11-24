#!/bin/bash

# requires the following packages:
# - ffmpeg

musicPath="/opt/randomSong/music"

# Start up notification
ffplay -nodisp -autoexit tone.mp3

function play() {
    ffplay -nodisp -autoexit tone.mp3   #notify button has been pressed
    ls music |sort -R |tail -1 |while read file; do     #list music files and select the last one
    ffplay -nodisp -autoexit "$musicPath/$file" #play music
  done
}

# Find the ID of the accessible button
MOUSE_ID=$(xinput list | grep 'USB Wheel Mouse' | awk -F'[^0-9]+' '{ print $2 }')

STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[1]' | sort)
while true; do
    sleep 0.2
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[1]' | sort)
    comm -13 <(echo "$STATE1") <(echo "$STATE2")

    if [ "$STATE2" != "$STATE1" ]; then
      play
    fi

    clear
    echo "Press the button to play a song!"
done
