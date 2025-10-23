#!/bin/sh

set -e

cd "$(dirname "$0")/duckdb"

git bisect start
git bisect good v1.3.2
git bisect bad v1.4.0
exec git bisect run ../test/run.sh