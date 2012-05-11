#!/bin/bash

# replace spaces with underscores
CLEAN_NAME=${1// /_}
# now, clean out anything that's not alphanumeric or an underscore
CLEAN_NAME=${CLEAN_NAME//[^a-zA-Z0-9_]/}
# finally, lowercase with TR
CLEAN_NAME=`echo -n $CLEAN_NAME | tr A-Z a-z`

gvpr -f reverse.gvpr        | # Reverse the links reading from stdin
    dijkstra "$1" -d        | # Compute the distance from the person to each of
                              # their ancestors
    gvpr "E[head.dist]"     | # Strip the edges who point to something without 
                              # a link to the person
    gvpr -f reverse.gvpr    |
    dot -Gmclimit=1000.0 -Tpng -o"$CLEAN_NAME.png" # Render the png
