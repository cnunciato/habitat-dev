#!/bin/bash

for shard in {0..127}
do
  sql="SET SEARCH_PATH TO shard_$shard; DROP FUNCTION IF EXISTS insert_origin_package_v2(bigint, bigint, text, text, text, text, text, text, text, text, text);"
  echo "$sql" | "$(hab pkg path core/postgresql)/bin/psql" -U hab builder_originsrv
done
