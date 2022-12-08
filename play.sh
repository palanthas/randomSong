#!/bin/bash

# requires the following packages:
# - ffmpeg

musicPath="/opt/randomSong/music"
d_then=$(date -d '+15minute' +'%H%M')

# Start up notification
ffplay -nodisp -autoexit tone.mp3

function play() {
    ffplay -nodisp -autoexit tone.mp3   #notify button has been pressed
    ls music |sort -R |tail -1 |while read file; do     #list music files and select the last one
    ffplay -nodisp -autoexit "$musicPath/$file" #play music
    d_last=$(date +%s) #Last time music was played
  done
}

function autoplay() {
  d_now=$(date +'%H%M')
  d_day=$(date +'%a')

  if [ $d_now -ge $d_then ];
  then
    if [ $d_now -lt 1600 ] && [ $d_now -gt 0800 ] && [ "$d_day" -ne "Sat" ] && [ "$d_day" -ne "Sun" ];
      then
        d_then=$(date -d '+15minute' +'%H%M')
        play
      else
        d_then=0800
      fi
  fi
}

MOUSE_ID=$(xinput list | grep 'USB Wheel Mouse' | awk -F'[^0-9]+' '{ print $2 }')

STATE1=$(xinput --query-state $MOUSE_ID | grep 'button\[1]' | sort)
while true; do
    sleep 0.2
    STATE2=$(xinput --query-state $MOUSE_ID | grep 'button\[1]' | sort)
    comm -13 <(echo "$STATE1") <(echo "$STATE2")

    if [ "$STATE2" != "$STATE1" ]; then
      play
      d_then=$(date -d '+15minute' +'%H%M')
    fi

    # Check if autoplay timer has elapsed
    autoplay
    d_next=$(date -d $d_then +'%H:%M')

    # Output to screen
    clear
    echo "Press the button to play a song!"
    echo "Next autoplay: $d_next"
done
