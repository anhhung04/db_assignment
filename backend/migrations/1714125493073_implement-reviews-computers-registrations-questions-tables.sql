-- Up Migration
CREATE TABLE students_join_courses
(
    student_id UUID NOT NULL
        CONSTRAINT students_join_courses_students_student_id_fk
            REFERENCES students
            ON DELETE CASCADE,
    course_id  UUID NOT NULL
        CONSTRAINT students_join_courses_courses_course_id_fk
            REFERENCES courses,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    current_price DOUBLE PRECISION,
    currency currency_type,
    CONSTRAINT students_join_courses_pk
        PRIMARY KEY (course_id, student_id)
);

CREATE TABLE reviews
(
    id         SERIAL NOT NULL,
    comment    TEXT,
    rating     FLOAT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    course_id UUID NOT NULL
        CONSTRAINT reviews_courses_course_id_fk
            REFERENCES courses
            ON DELETE CASCADE,
    student_id UUID NOT NULL
        CONSTRAINT reviews_students_student_id_fk
            REFERENCES students
            ON DELETE CASCADE
);

-- CREATE TABLE registrations
-- (
--     id         UUID NOT NULL
--         CONSTRAINT registrations_PK
--             PRIMARY KEY,
--     content    TEXT,
--     status     status NOT NULL,
--     created_at TIMESTAMP,
--     user_id    UUID NOT NULL
--         CONSTRAINT registrations_users_user_id_fk
--             REFERENCES users
--             ON DELETE CASCADE
-- );

CREATE TABLE computers
(
    comp_id       UUID NOT NULL
        CONSTRAINT computers_pk
            PRIMARY KEY,
    status        STATUS,
    model         VARCHAR(100),
    buy_at        TIMESTAMP,
    warranty_date DATE,
    time_supplied TIMESTAMP DEFAULT NOW(),
    user_id       UUID
        CONSTRAINT computers_users_id_fk
            REFERENCES users
            ON DELETE CASCADE
);

CREATE TABLE registrations
(
    id      UUID                    NOT NULL
        CONSTRAINT registrations_pk
            PRIMARY KEY,
    time    TIMESTAMP DEFAULT NOW() NOT NULL,
    content TEXT,
    status  STATUS
);

CREATE TABLE student_course_registrations
(
    student_id      UUID NOT NULL
        CONSTRAINT student_course_registrations_users_id_fk
            REFERENCES users
            ON DELETE CASCADE,
    course_id       UUID NOT NULL
        CONSTRAINT student_course_registrations_courses_course_id_fk
            REFERENCES courses
            ON DELETE CASCADE,
    registration_id UUID NOT NULL
        CONSTRAINT student_course_registrations_registrations_id_fk
            REFERENCES registrations
            ON DELETE CASCADE,
    CONSTRAINT student_course_registrations_pk
        PRIMARY KEY (course_id, student_id, registration_id)
);


CREATE TABLE sections
(
    id           UUID NOT NULL
        CONSTRAINT sections_pk
            PRIMARY KEY,
    material_uri VARCHAR(200),
    exam_id      UUID
        CONSTRAINT sections_exams_id_fk
            REFERENCES exams
            ON DELETE CASCADE
);

CREATE TABLE subsections
(
    id         UUID NOT NULL
        CONSTRAINT subsections_pk
            PRIMARY KEY,
    title      VARCHAR(100),
    content    TEXT,
    section_id UUID
        CONSTRAINT subsections_sections_id_fk
            REFERENCES sections
            ON DELETE CASCADE
);

CREATE TABLE questions
(
    id            UUID NOT NULL
        CONSTRAINT questions_pk
            PRIMARY KEY,
    content       TEXT,
    subsection_id UUID
        CONSTRAINT questions_subsections_id_fk
            REFERENCES subsections
            ON DELETE CASCADE,
    score         DOUBLE PRECISION
);

CREATE TABLE wrong_answers
(
    id             UUID         NOT NULL
        CONSTRAINT wrong_answers_pk
            PRIMARY KEY,
    student_answer VARCHAR(100) NOT NULL,
    taking_exam_id UUID
        CONSTRAINT wrong_answers_taking_exam_id_fk
            REFERENCES taking_exam (id)
            ON DELETE CASCADE,
    answer_id      UUID         NOT NULL
        CONSTRAINT wrong_answers_questions_id_fk
            REFERENCES questions
            ON DELETE CASCADE
);


-- Down Migration
-- DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS students_join_courses;
DROP TABLE IF EXISTS computers;
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS student_course_registrations;
DROP TABLE IF EXISTS sections;
DROP TABLE IF EXISTS subsections;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS wrong_answers;
