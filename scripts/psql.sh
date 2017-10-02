#!/bin/bash

for shard in {0..127}
do
  echo $shard
  sql="SET SEARCH_PATH TO shard_$shard; SELECT name FROM origins;"
  echo "$sql" | "$(hab pkg path core/postgresql)/bin/psql" -U hab builder_originsrv
done
