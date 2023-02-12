CREATE SCHEMA public;

CREATE TABLE public.academic_year (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    CONSTRAINT academic_year_pkey PRIMARY KEY (id)
);

CREATE TABLE public.auditory_type (
    id smallserial NOT NULL,
    auditory_title character varying(255) NOT NULL,
    CONSTRAINT auditory_type_pkey PRIMARY KEY (id)
);

CREATE TYPE public.t_week_parity_type AS ENUM ('a', 'b');
CREATE TABLE public.week (
    id serial NOT NULL,
    start_date integer NOT NULL,
    end_date integer NOT NULL,
    type public.t_week_parity_type NOT NULL,
    CONSTRAINT week_pkey PRIMARY KEY (id)
);

