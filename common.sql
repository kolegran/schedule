CREATE SCHEMA common;

CREATE TABLE common.division (
    id integer NOT NULL,
    department character varying(255) NOT NULL,
    institute character varying(255) NOT NULL,
    id_division integer NOT NULL,
    CONSTRAINT division_pkey PRIMARY KEY (id),
    CONSTRAINT division_id_division_fkey FOREIGN KEY (id_division)
        REFERENCES common.division (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);
