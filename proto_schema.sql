-- CLDF phonological-rules prototype schema (SQLite)
-- Etymon = single proto-form; rule participation is cascade-scoped and per-firing.

PRAGMA foreign_keys = ON;

-- Attested leaves AND reconstructed intermediate/proto nodes, both keyed by glottocode.
CREATE TABLE Language (
    id         INTEGER PRIMARY KEY,
    name       TEXT NOT NULL,
    glottocode TEXT
);

-- A phonological rule, defined once and referenced by many cascades.
CREATE TABLE Rule (
    ruleid  INTEGER PRIMARY KEY,
    input   TEXT NOT NULL,
    output  TEXT NOT NULL,
    context TEXT
);

-- A proto-form. proto_language_id should point at a (typically reconstructed) Language node.
CREATE TABLE Etymon (
    id                INTEGER PRIMARY KEY,
    concept           TEXT NOT NULL,
    proto_language_id INTEGER REFERENCES Language(id)
);

-- An ordered chain of rules from a source (proto) language to a target language.
CREATE TABLE Cascade (
    id                 INTEGER PRIMARY KEY,
    source_language_id INTEGER REFERENCES Language(id),
    target_language_id INTEGER REFERENCES Language(id)
);

-- The ordered chronology. A rule MAY recur within one cascade (different positions).
-- Keyed on (cascade_id, position) so each firing is individually addressable.
CREATE TABLE CascadeRule (
    cascade_id INTEGER NOT NULL REFERENCES Cascade(id),
    ruleid     INTEGER NOT NULL REFERENCES Rule(ruleid),
    position   INTEGER NOT NULL,
    PRIMARY KEY (cascade_id, position)
);

-- Which etyma underwent which specific firing. ruleid is intentionally omitted
-- (normalised): recover it by joining back to CascadeRule on (cascade_id, position).
CREATE TABLE EtymonRule (
    etymon_id  INTEGER NOT NULL REFERENCES Etymon(id),
    cascade_id INTEGER NOT NULL,
    position   INTEGER NOT NULL,
    PRIMARY KEY (etymon_id, cascade_id, position),
    FOREIGN KEY (cascade_id, position) REFERENCES CascadeRule(cascade_id, position)
);

-- Supporting indexes for the common reverse lookups.
CREATE INDEX idx_cascaderule_rule    ON CascadeRule(ruleid);
CREATE INDEX idx_etymonrule_step     ON EtymonRule(cascade_id, position);
CREATE INDEX idx_cascade_source      ON Cascade(source_language_id);
CREATE INDEX idx_cascade_target      ON Cascade(target_language_id);
CREATE INDEX idx_etymon_protolang    ON Etymon(proto_language_id);
