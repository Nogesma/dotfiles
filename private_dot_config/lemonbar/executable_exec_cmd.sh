#!/usr/bin/bash

while read -r line
do
	sh -c "$line"
	pkill -x -USR1 lemonbar.sh
done
