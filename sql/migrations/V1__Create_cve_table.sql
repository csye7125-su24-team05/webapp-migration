-- cve schema

CREATE TABLE cve.cve_records (
    id SERIAL PRIMARY KEY,
    cve_id VARCHAR(255) NOT NULL,
    cve_data JSONB NOT NULL,
    version VARCHAR(255) NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(cve_id, version)
);

-- GIN = Generalized Inverted Index (index in PostgreSQL designed to handle indexing for complex data types like jsonb, array, etc.)

CREATE INDEX idx_cve_id ON cve.cve_records (cve_id);
CREATE INDEX idx_cve_data ON cve.cve_records USING GIN (cve_data);