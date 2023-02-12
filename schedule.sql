CREATE SCHEMA schedule;

CREATE TABLE schedule.contingent (
    id bigint NOT NULL,
    number_of_the_curriculum integer NOT NULL,
    course integer NOT NULL,
    CONSTRAINT contingent_pkey PRIMARY KEY (id)
);

CREATE TABLE schedule.time_table (
    id smallserial NOT NULL,
    title character varying(255) NOT NULL,
    CONSTRAINT time_table_pkey PRIMARY KEY (id)
);

CREATE TABLE schedule.classes_schedule_template (
    id serial NOT NULL,
    weekday character varying(255) NOT NULL,
    id_week_first integer NOT NULL,
    CONSTRAINT classes_schedule_template_pkey PRIMARY KEY (id),
    CONSTRAINT classes_schedule_template_id_week_first_fkey FOREIGN KEY (id_week_first)
        REFERENCES public.week (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.classes_schedule (
    id bigserial NOT NULL,
    date_for_a_day integer NOT NULL,
    id_time_table smallint NOT NULL,
    id_classes_schedule_template integer NOT NULL,
    CONSTRAINT classes_schedule_pkey PRIMARY KEY (id),
    CONSTRAINT classes_schedule_id_time_table_fkey FOREIGN KEY (id_time_table)
        REFERENCES schedule.time_table (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT classes_schedule_id_classes_schedule_template_fkey FOREIGN KEY (id_classes_schedule_template)
        REFERENCES schedule.classes_schedule_template (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.timeslot (
    id smallserial NOT NULL,
    id_time_table smallserial NOT NULL,
    class_number integer NOT NULL,
    start_time integer NOT NULL,
    end_time integer NOT NULL,
    pause_start_time integer NOT NULL,
    pause_end_time integer NOT NULL,
    CONSTRAINT timeslot_pkey PRIMARY KEY (id),
    CONSTRAINT timeslot_id_time_table_fkey FOREIGN KEY (id_time_table)
        REFERENCES schedule.time_table (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.student_group (
    id integer NOT NULL,
    group_title character varying(255) NOT NULL,
    number_of_students integer NOT NULL,
    number_of_subgroups integer NOT NULL,
    id_contingent bigint[],
    id_academic_year integer NOT NULL,
    id_division integer NOT NULL,
    CONSTRAINT student_group_pkey PRIMARY KEY (id),
    CONSTRAINT student_group_id_academic_year_fkey FOREIGN KEY (id_academic_year)
        REFERENCES public.academic_year (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT student_group_id_division_fkey FOREIGN KEY (id_division)
        REFERENCES common.division (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.group_layout (
    id smallserial NOT NULL,
    id_division integer NOT NULL,
    id_student_group integer[],
    CONSTRAINT group_layout_pkey PRIMARY KEY (id),
    CONSTRAINT group_layout_id_division_fkey FOREIGN KEY (id_division)
        REFERENCES common.division (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.subject (
    id serial NOT NULL,
    subject_title character varying(255) NOT NULL,
    lectures_amount integer NOT NULL,
    practicals_amount integer NOT NULL,
    labs_amount integer NOT NULL,
    id_contingent bigint NOT NULL,
    CONSTRAINT subject_pkey PRIMARY KEY (id),
    CONSTRAINT subject_id_contingent_fkey FOREIGN KEY (id_contingent)
        REFERENCES schedule.contingent (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.auditory (
    id smallserial NOT NULL,
    learning_campus integer NOT NULL,
    auditory_number integer NOT NULL,
    maximum_number_of_places integer NOT NULL,
    id_auditory_type smallint NOT NULL,
    id_division integer NOT NULL,
    CONSTRAINT auditory_pkey PRIMARY KEY (id),
    CONSTRAINT auditory_id_auditory_type_fkey FOREIGN KEY (id_auditory_type)
        REFERENCES public.auditory_type (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT auditory_id_division_fkey FOREIGN KEY (id_division)
        REFERENCES common.division (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.teacher (
    id smallserial NOT NULL,
    grade character varying(255) NOT NULL,
    full_name character varying(255) NOT NULL,
    id_academic_year integer NOT NULL,
    id_division integer NOT NULL,
    CONSTRAINT teacher_pkey PRIMARY KEY (id),
    CONSTRAINT teacher_id_academic_year_fkey FOREIGN KEY (id_academic_year)
        REFERENCES public.academic_year (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT teacher_id_division_fkey FOREIGN KEY (id_division)
        REFERENCES common.division (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TABLE schedule.class (
    id bigserial NOT NULL,
    id_classes_schedule bigint NOT NULL,
    id_timeslot smallint NOT NULL,
    id_student_group integer NOT NULL,
    subgroups smallint[],
    id_subject integer NOT NULL,
    id_teacher smallint NOT NULL,
    id_auditory smallint NOT NULL,
    CONSTRAINT class_pkey PRIMARY KEY (id),
    CONSTRAINT class_id_classes_schedule_fkey FOREIGN KEY (id_classes_schedule)
        REFERENCES schedule.classes_schedule (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_id_timeslot_fkey FOREIGN KEY (id_timeslot)
        REFERENCES schedule.timeslot (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_id_student_group_fkey FOREIGN KEY (id_student_group)
        REFERENCES schedule.student_group (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_id_subject_fkey FOREIGN KEY (id_subject)
        REFERENCES schedule.subject (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_id_teacher_fkey FOREIGN KEY (id_teacher)
        REFERENCES schedule.teacher (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_id_auditory_fkey FOREIGN KEY (id_auditory)
        REFERENCES schedule.auditory (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);

CREATE TYPE schedule.t_class_repetition_type AS ENUM ('weekly', 'biweekly', 'triweekly');
CREATE TABLE schedule.class_template (
    id serial NOT NULL,
    id_classes_schedule_template integer NOT NULL,
    class_number integer NOT NULL,
    id_student_group integer NOT NULL,
    subgroups smallint[],
    id_subject integer NOT NULL,
    id_teacher smallint NOT NULL,
    id_auditory smallint NOT NULL,
    repetition_type schedule.t_class_repetition_type,
    repetition_origin smallint,
    CONSTRAINT class_template_pkey PRIMARY KEY (id),
    CONSTRAINT class_template_id_classes_schedule_template_fkey FOREIGN KEY (id_classes_schedule_template)
        REFERENCES schedule.classes_schedule_template (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_template_id_student_group_fkey FOREIGN KEY (id_student_group)
        REFERENCES schedule.student_group (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
     CONSTRAINT class_template_id_subject_fkey FOREIGN KEY (id_subject)
        REFERENCES schedule.subject (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_template_id_teacher_fkey FOREIGN KEY (id_teacher)
        REFERENCES schedule.teacher (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE,
    CONSTRAINT class_template_id_auditory_fkey FOREIGN KEY (id_auditory)
        REFERENCES schedule.auditory (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY IMMEDIATE
);
