#!/bin/bash

space='  '
width='50'
i=0

while true; do
	while true; do
		if [ "$i" = "$width" ]; then
			d="$width"
			break
		else
			x="$x$space"
			i=$(($i + 1))
		fi
		sleep 0.05
		printf "%s\n" "$x"xD""
	done

	while true; do
		if [ "$d" = "0" ]; then
			i=1
			break
		else
			x="${x:2}"
			d=$(($d - 1))
		fi
		sleep 0.05
		printf "%s\n" "$x"xD""
	done
done

