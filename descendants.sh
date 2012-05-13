#!/bin/bash

# replace spaces with underscores
CLEAN_NAME=${1// /_}
# now, clean out anything that's not alphanumeric or an underscore
CLEAN_NAME=${CLEAN_NAME//[^a-zA-Z0-9_]/}
# finally, lowercase with TR
CLEAN_NAME=`echo -n $CLEAN_NAME | tr A-Z a-z`

dijkstra "$1" -d        | # Compute the distance from the person to each of
                          # their descendants
gvpr -c "BEG_G{}
         E[head.dist == 0.0]{tail.dist = -4.0;}
            // Set the parents of the person to -4.0
         BEG_G{}
         E[head.dist == 1.0 && tail.dist <= 0.0]{tail.dist = -3.0;}
            // Set the spouses to -3 if they're not already descendants
         BEG_G{ \$tvtype = TV_en; }
         E[head.dist == -3.0 && tail.dist == -3.0]{delete(\$G,$);}
            // remove links between spouses
         N[dist == -1.0]{delete(\$G,$);}
            // Remove all the other nodes
         BEG_G{graph_t s = subg(\$G, \"spouses\"); s.rank=\"same\";} 
            // put all of the spouses who aren't descendants into the same rank
         N[dist == -3.0]{ clone(s,$); }
        " #|
#dot -Gmclimit=10000.0 -Tpng -o"$CLEAN_NAME.png" # Render the png
