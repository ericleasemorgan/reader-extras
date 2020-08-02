#!/usr/bin/env bash

# carrel2diagram.sh - a front-end to ./bin/carrel2json.py and ./bin/template2html.sh

# Eric Lease Morgan <emorgan@nd.edu>
# August 7, 2019 - first documentation


# configure
CARREL2JSON='./bin/carrel2json.py'
CARRELS='./library'
TEMPLATE2HTML='./bin/template2html-diagram.sh'

# sanity check
if [[ -z $1 ]]; then
	echo "Usage: $0 <carrel>" >&2
	exit
fi

# get input 
CARREL=$1

# do the work and done
$CARREL2JSON   $CARREL > "$CARRELS/$CARREL/etc/$CARREL.json"
$TEMPLATE2HTML $CARREL > "$CARRELS/$CARREL/$CARREL-diagram.html"
open "$CARRELS/$CARREL/$CARREL-diagram.html"
exit
