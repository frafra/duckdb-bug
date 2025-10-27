#!/bin/sh

set -e

cd "$(dirname "$0")/duckdb"

git bisect start
#git bisect good v1.3.2
#git bisect bad v1.4.0
git bisect good a8a377580cc5d26ae90f16b41affad24ac6ee833
git bisect bad a6ce5af2ab4b4b7739251bfe149e55e09331d041
exec git bisect run ../test/run.sh