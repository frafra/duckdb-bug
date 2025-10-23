LOAD fts;

-- example from https://duckdb.org/docs/stable/core_extensions/full_text_search
CREATE TABLE documents (
    document_identifier VARCHAR,
    text_content VARCHAR,
    author VARCHAR,
    doc_version INTEGER
);
INSERT INTO documents
    VALUES ('doc1',
            'The mallard is a dabbling duck that breeds throughout the temperate.',
            'Hannes Mühleisen',
            3),
           ('doc2',
            'The cat is a domestic species of small carnivorous mammal.',
            'Laurens Kuiper',
            2
           );
PRAGMA create_fts_index(
    'documents', 'document_identifier', 'text_content', 'author'
);

-- custom table
CREATE TABLE queries (
    query VARCHAR
);
INSERT INTO queries
    VALUES (('cat')), (('dog')), (('duck'));

-- custom query
SELECT query, text_content
FROM queries
LEFT JOIN LATERAL(
    SELECT *,
        fts_main_documents.match_bm25(document_identifier, query) AS score
    FROM documents
    WHERE score IS NOT NULL
    ORDER BY score DESC
    LIMIT 1
) ON true
ORDER BY query
;