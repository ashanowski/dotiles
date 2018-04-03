#!/usr/bin/env bash

UPDATES="$(xavup -i)"
[ "$UPDATES" = 0 ] && echo "Void fully updated"
[ "$UPDATES" != 0 ] && echo "Void updates: " $(xavup -i)
