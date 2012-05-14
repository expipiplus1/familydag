#!/bin/bash

# replace spaces with underscores
CLEAN_NAME=${1// /_}
# now, clean out anything that's not alphanumeric or an underscore
CLEAN_NAME=${CLEAN_NAME//[^a-zA-Z0-9_]/}
# finally, lowercase with TR
CLEAN_NAME=`echo -n $CLEAN_NAME | tr A-Z a-z`

( tee >(./descendants.sh "$CLEAN_NAME") >(./ancestors.sh "$CLEAN_NAME") > /dev/null ) | 
gvpr -f merge.gvpr

