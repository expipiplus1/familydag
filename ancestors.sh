#!/bin/bash

# first, strip underscores
CLEAN=${1//_/}
# next, replace spaces with underscores
CLEAN=${CLEAN// /_}
# now, clean out anything that's not alphanumeric or an underscore
CLEAN=${CLEAN//[^a-zA-Z0-9_]/}
# finally, lowercase with TR
CLEAN=`echo -n $CLEAN | tr A-Z a-z`

gvpr -f reverse.gvpr | dijkstra "$1" -d | gvpr "E[tail.dist > 0]" | gvpr -f reverse.gvpr | dot -Gmclimit=10000.0 -Tpng -o"$CLEAN.png"
