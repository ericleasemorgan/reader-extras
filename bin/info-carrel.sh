#!/usr/bin/env bash

# info-carrel.sh - given the name of a carrel, output a list of its characteristics

# Eric Lease Morgan <emorgan@nd.edu>
# (c) University of Notre Dame; distributed under a GNU Public License

# August 7, 2020 - first cut


# configure
LIBRARY='./library'
DB='etc/reader.db'
ZIP='study-carrel.zip';
MAX=12

if [[ -z $1 ]]; then
	echo "Usage: $0 <carrel>" >&2
	exit
fi

# initialize
SHORTNAME=$1
CARREL="$LIBRARY/$SHORTNAME"

ITEMS=$( echo "SELECT COUNT( id ) FROM bib;" | sqlite3 "$CARREL/$DB" )
WORDS=$( echo "SELECT SUM( words ) FROM bib;" | sqlite3 "$CARREL/$DB" )
FLESCH=$( echo "SELECT AVG( flesch ) FROM bib;" | sqlite3 "$CARREL/$DB" )
KEYWORDS=$( echo "SELECT LOWER( keyword ) FROM wrd GROUP BY LOWER( keyword ) ORDER BY COUNT( LOWER ( keyword ) ) DESC LIMIT $MAX;" | sqlite3 "$CARREL/$DB" )
NOUNS=$( echo "SELECT lemma FROM pos WHERE pos LIKE 'N%' GROUP BY lemma ORDER BY COUNT( lemma ) DESC LIMIT $MAX;" | sqlite3 "$CARREL/$DB" )
VERBS=$( echo "SELECT lemma FROM pos WHERE pos LIKE 'V%' GROUP BY lemma ORDER BY COUNT( lemma ) DESC LIMIT $MAX;" | sqlite3 "$CARREL/$DB" )
ADJECTIVES=$( echo "SELECT lemma FROM pos WHERE pos LIKE 'J%' GROUP BY lemma ORDER BY COUNT( lemma ) DESC LIMIT $MAX;" | sqlite3 "$CARREL/$DB" )
NUMBEROFPERSONS=$( echo "SELECT COUNT( DISTINCT( entity ) ) FROM ent WHERE type IS 'PERSON';" | sqlite3 "$CARREL/$DB" )
PERSONS=$( echo "SELECT entity FROM ent WHERE type IS 'PERSON' GROUP BY entity ORDER BY COUNT( entity ) DESC LIMIT $MAX;" | sqlite3 "$CARREL/$DB" )
PLACES=$( echo "SELECT entity FROM ent WHERE type IS 'GPE' GROUP BY entity ORDER BY COUNT( entity ) DESC LIMIT $MAX;" | sqlite3 "$CARREL/$DB" )
NUMBEROFPLACES=$( echo "SELECT COUNT( DISTINCT( entity ) ) FROM ent WHERE type IS 'GPE';" | sqlite3 "$CARREL/$DB" )

# format outputs
KEYWORDS=$( echo $KEYWORDS | sed 's/ /, /g' )
PERSONS=$( echo $PERSONS | sed 's/ /, /g' )
PLACES=$( echo $PLACES | sed 's/ /, /g' )
NOUNS=$( echo $NOUNS | sed 's/ /, /g' )
VERBS=$( echo $VERBS | sed 's/ /, /g' )
ADJECTIVES=$( echo $ADJECTIVES | sed 's/ /, /g' )
SIZE=$( printf "%'.f" $SIZE )
WORDS=$( printf "%'.f" $WORDS )
ITEMS=$( printf "%'.f" $ITEMS )
NUMBEROFPERSONS=$( printf "%'.f" $NUMBEROFPERSONS )
NUMBEROFPLACES=$( printf "%'.f" $NUMBEROFPLACES )
FLESCH=$( printf "%'.f" $FLESCH )

# output
echo
echo "              name: $SHORTNAME"
echo "             items: $ITEMS"
echo "             words: $WORDS"
echo "            flesch: $FLESCH"
echo
echo "          keywords: $KEYWORDS"
echo "             nouns: $NOUNS"
echo "             verbs: $VERBS"
echo "        adjectives: $ADJECTIVES"
echo
echo "  number of people: $NUMBEROFPERSONS"
echo "           persons: $PERSONS"
echo
echo "  number of places: $NUMBEROFPLACES"
echo "            places: $PLACES"
echo

# done
exit
