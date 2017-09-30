#!/bin/bash

source /scripts/env.sh

for pkg in /hab/cache/artifacts/core*.hart; do
  hab pkg upload --url http://localhost:9636/v1 --auth "$HAB_AUTH_TOKEN" "$pkg" --channel stable
done
