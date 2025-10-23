# https://github.com/duckdb/duckdb/commit/2da90f6c05040f4806d2ff3fecb3801e9d3bcb09
duckdb_extension_load(fts
        LOAD_TESTS
        DONT_LINK
        GIT_URL https://github.com/duckdb/duckdb-fts
        GIT_TAG 3aa6a180b9c101d78070f5f7214c27552bb091c8
        TEST_DIR test/sql
        APPLY_PATCHES
)