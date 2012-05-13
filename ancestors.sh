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
gvpr -f reverse.gvpr    |
gvpr -c "BEG_G{}
         E[tail.dist == 0.0]{head.dist = -2.0;}  // Set the children to -2.0
         BEG_G{}
         E[head.dist == -2.0]{tail.dist = -3.0} // Set the parents of the chilren to -3.0
         BEG_G{ \$tvtype = TV_en; }              
         E[head.dist == -3.0 && tail.dist == -3.0]{delete(\$G,$);} // remove links between parents
         N[dist == -1.0]{delete(\$G,$);}         // Remove all the other nodes
        " # |
#dot -Gmclimit=1000.0 -Tpng -o"$CLEAN_NAME.png" # Render the png
