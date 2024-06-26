-- Up Migration
CREATE TYPE account_type AS ENUM ('operator', 'teacher', 'student', 'user', 'admin');
CREATE TYPE status AS ENUM ('active', 'inactive');
CREATE TYPE document_type AS ENUM ('book', 'dictionary', 'mock_test');
CREATE TYPE ebook_type AS ENUM ('theory', 'practical');
CREATE TYPE currency_type AS ENUM ('usd', 'vnd', 'eur');
CREATE TYPE course_type AS ENUM ('free', 'paid');
CREATE TYPE resource_type as ENUM ('videos', 'documents');

CREATE TABLE users
(
    username     TEXT         NOT NULL UNIQUE,
    password     VARCHAR(100) NOT NULL,
    fname        VARCHAR(100) NOT NULL,
    lname        VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    address      TEXT         NOT NULL,
    id           UUID         NOT NULL
        CONSTRAINT id
            PRIMARY KEY,
    avatar_url   TEXT,
    account_type account_type NOT NULL,
    phone_no     VARCHAR(11),
    birthday     DATE,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    account_balance DOUBLE PRECISION DEFAULT 0,
    display_name VARCHAR(100) NOT NULL DEFAULT ''
);

CREATE TABLE students
(
    english_level VARCHAR(50),
    study_history VARCHAR(150),
    target        VARCHAR(30),
    user_id       UUID  NOT NULL
        CONSTRAINT student_id
            PRIMARY KEY
                REFERENCES users
                ON DELETE CASCADE,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE activities
(
    activity_id SERIAL NOT NULL
        CONSTRAINT activity_id
            PRIMARY KEY,
    action          VARCHAR(200)  NOT NULL,
    resource_id     UUID,
    note            TEXT,
    activist_id     UUID
        CONSTRAINT activity_activist_id_fk
            REFERENCES users
            ON DELETE CASCADE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE exams
(
    exam_id    UUID    NOT NULL
        CONSTRAINT exam_id
            PRIMARY KEY,
    duration  INTERVAL NOT NULL,
    title    VARCHAR(100) NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE teachers
(
    user_id           UUID NOT NULL
        CONSTRAINT teacher_id
            PRIMARY KEY
                REFERENCES users
                ON DELETE CASCADE,
    educational_level VARCHAR(150),
    rating            DOUBLE PRECISION,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

-- CREATE TABLE assistants
-- (
--     teacher_id   UUID NOT NULL
--         CONSTRAINT teacher_id
--             REFERENCES teachers,
--     assistant_id UUID NOT NULL,
--     created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
--     updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
--     CONSTRAINT assistant_id
--         PRIMARY KEY (teacher_id, assistant_id)
-- );

CREATE TABLE permissions
(
    user_id     UUID
        CONSTRAINT permission_id
            REFERENCES users
            ON DELETE CASCADE,
    read        BOOLEAN DEFAULT FALSE,
    "create"    BOOLEAN DEFAULT FALSE,
    update      BOOLEAN DEFAULT FALSE,
    delete      BOOLEAN DEFAULT FALSE,
    resource_id UUID DEFAULT '00000000-0000-0000-0000-000000000000',
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT permissions_id
        PRIMARY KEY (user_id, resource_id)
);

CREATE TABLE taking_exam
(
    id UUID NOT NULL UNIQUE,
    student_id UUID    NOT NULL
        CONSTRAINT taking_exam_students_student_id_fk
            REFERENCES students
            ON DELETE CASCADE,
    exam_id    UUID    NOT NULL
        CONSTRAINT taking_exam_exams_exam_id_fk
            REFERENCES exams
            ON DELETE CASCADE,
    score      NUMERIC NOT NULL,
    ranking    NUMERIC NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT taking_id
        PRIMARY KEY (student_id, exam_id, id)
);

-- Down Migration
DROP TABLE IF EXISTS taking_exam;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS libraries;
-- DROP TABLE IF EXISTS assistants;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS pgmigrations;
DROP TYPE IF EXISTS status;
DROP TYPE IF EXISTS account_type;
DROP TYPE IF EXISTS document_type;
DROP TYPE IF EXISTS ebook_type;
DROP TYPE IF EXISTS currency_type;
DROP TYPE IF EXISTS course_type;
DROP TYPE IF EXISTS resource_type;
