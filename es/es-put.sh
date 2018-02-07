#!/bin/bash

die() { echo "$*"; exit 111; }

unset URL
URL=$1
[ -z $URL ] && die "Must specify domain endpoint"

INDEX="$URL/movies/"
MAPPING="${INDEX}_mapping/movie"

# 1. Delete index
curl -s -XDELETE "$INDEX" 

# 2. Re-create index with mapping (use dynamic mapping for all but t)
MAPPING="
{
  \"mappings\" : {
    \"movie\" : {
      \"properties\" : {
        \"@timestamp\" : { \"type\" : \"date\", \"format\": \"yyyyMMdd\" }
      }
    }
  }
}"
curl -s -XPUT "$INDEX" -d "$MAPPING"

# 3. Put data
curl -XPOST $URL/_bulk --data-binary @es/bulk-movies.json -H 'Content-Type: application/json'