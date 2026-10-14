#!/usr/bin/env bash

set -euo pipefail

echo "branch: $BRANCH"
echo "base:   $BASE"
echo "head:   $HEAD"
echo "changed files:"
for f in $ALL_CHANGED; do
  echo "  $f"
done
