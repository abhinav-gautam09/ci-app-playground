#!/usr/bin/env bash

set -euo pipefail

failed=0
for env in apps/*/config.env; do
  app=$(basename "$(dirname "$env")")
  name=$(sed -n 's/^APP_NAME=//p' "$env")
  replicas=$(sed -n 's/^REPLICAS=//p' "$env")

  if [ "$name" != "$app" ]; then
    echo "FAIL $env: APP_NAME is '$name', expected '$app'"
    failed=1
  fi
  if ! [[ "$replicas" =~ ^[0-9]+$ ]]; then
    echo "FAIL $env: REPLICAS is '$replicas', expected a number"
    failed=1
  fi
done

[ "$failed" -eq 0 ] && echo "OK all apps have a matching APP_NAME and numeric REPLICAS"
exit "$failed"
