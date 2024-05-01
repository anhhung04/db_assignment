-- Up Migration
CREATE TYPE account_type AS ENUM ('operator', 'teacher', 'student', 'user', 'admin');

CREATE TYPE status AS ENUM ('active', 'inactive');

CREATE TABLE users
(
    username     TEXT         NOT NULL UNIQUE,
    password     VARCHAR(100) NOT NULL,
    fname        VARCHAR(100) NOT NULL,
    lname        VARCHAR(100) NOT NULL,
    display_name VARCHAR(100) NOT NULL DEFAULT '',
    email        VARCHAR(100) NOT NULL UNIQUE,
    address      TEXT         NOT NULL,
    id           UUID         NOT NULL
        CONSTRAINT id
            PRIMARY KEY,
    avatar_url   TEXT,
    account_type account_type NOT NULL,
    status       status       NOT NULL,
    phone_no     VARCHAR(11),
    birthday     DATE,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW()
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
    action      VARCHAR(200)  NOT NULL,
    resource_id        UUID,
    note        TEXT,
    activist_id     UUID
        CONSTRAINT activist_id
            REFERENCES users,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- CREATE TABLE exams
-- (
--     exam_id    UUID    NOT NULL
--         CONSTRAINT exam_id
--             PRIMARY KEY,
--     questions  TEXT    NOT NULL,
--     answers    TEXT    NOT NULL,
--     duration   INTEGER NOT NULL,
--     course_id UUID    NOT NULL,
--     created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
--     updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
-- );


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

-- CREATE TABLE libraries
-- (
--     library_id UUID        NOT NULL
--         CONSTRAINT library_id
--             PRIMARY KEY,
--     name       VARCHAR(50) NOT NULL,
--     created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
--     updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
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
    resource_id UUID,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT permissions_id
        PRIMARY KEY (user_id, resource_id)
);

-- CREATE TABLE taking_exam
-- (
--     user_id UUID    NOT NULL
--         CONSTRAINT taking_exam_students_student_id_fk
--             REFERENCES students
--             ON DELETE CASCADE
--             ON UPDATE CASCADE,
--     exam_id    UUID    NOT NULL
--         CONSTRAINT taking_exam_exams_exam_id_fk
--             REFERENCES exams
--             ON DELETE CASCADE
--             ON UPDATE CASCADE,
--     score      NUMERIC NOT NULL,
--     ranking    NUMERIC NOT NULL,
--     created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
--     updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
--     CONSTRAINT taking_id
--         PRIMARY KEY (user_id, exam_id)
-- );

-- Down Migration
DROP TABLE IF EXISTS taking_exam;
DROP TABLE IF EXISTS permissions;
-- DROP TABLE IF EXISTS libraries;
-- DROP TABLE IF EXISTS assistants;
DROP TABLE IF EXISTS teachers;
-- DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS status;
DROP TYPE IF EXISTS account_type;