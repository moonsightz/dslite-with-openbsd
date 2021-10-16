#!/bin/sh

ifconfig WAN0 | grep temporary | awk '{if (match($0, /pltime ([0-9]+)/)) {printf "%s %d\n", $2, substr($0, RSTART + 7, RLENGTH - 7); }}' | sort -rk 2 | head -n 1 | cut -f 1 -d ' '
# Before 6.8
#ifconfig WAN0 | grep autoconfprivacy | awk '{if (match($0, /pltime ([0-9]+)/)) {printf "%s %d\n", $2, substr($0, RSTART + 7, RLENGTH - 7); }}' | sort -rk 2 | head -n 1 | cut -f 1 -d ' '
