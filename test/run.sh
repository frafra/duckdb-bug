#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/../duckdb"

# fetch fts from git if the current commit older than https://github.com/duckdb/duckdb/commit/2da90f6c05040f4806d2ff3fecb3801e9d3bcb09
if git merge-base --is-ancestor HEAD 2da90f6c05040f4806d2ff3fecb3801e9d3bcb09
then
  export EXTENSION_CONFIGS="../extension_config.cmake"
else
  export BUILD_EXTENSIONS="fts"
fi

# fix untestable commits belonging to https://github.com/duckdb/duckdb/pull/17459
if git merge-base --is-ancestor HEAD a6ce5af2ab4b4b7739251bfe149e55e09331d041 && \
    git merge-base --is-ancestor a8a377580cc5d26ae90f16b41affad24ac6ee833 HEAD
then
  git cherry-pick --no-commit a6ce5af2ab4b4b7739251bfe149e55e09331d041
fi

make clean

TARGET=debug
GEN=ninja EXTENSION_STATIC_BUILD=1 make $TARGET || exit 125
export PATH="$(realpath build/$TARGET):$PATH"
duckdb -c "INSTALL 'build/$TARGET/extension/fts/fts.duckdb_extension';" || exit 125

cd ../test
duckdb -unsigned -csv -batch < query.sql > current.csv || exit 125
exec diff -q expected.csv current.csv >/dev/null