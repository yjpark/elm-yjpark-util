#!/usr/bin/env bash

make

while true; do
    if [[ "$(uname)" == "Darwin" ]]; then
        fswatch -L -1 . && echo "" && echo `date +"[%H:%M]"`"----------------------------------------------------------" && make;
    fi
    if [[ "$(uname)" == "Linux" ]]; then
        inotifywait -e modify -e create -e delete -r src lib && echo "" && echo `date +"[%H:%M]"`"----------------------------------------------------------" && make;
    fi
done
