-- Up Migration
CREATE TYPE account_type AS ENUM ('operator', 'teacher', 'student');

CREATE TYPE status AS ENUM ('active', 'inactive');

CREATE TABLE users
(
    username     TEXT         NOT NULL,
    password     VARCHAR(100) NOT NULL,
    fname        VARCHAR(100) NOT NULL,
    lname        VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    address      TEXT         NOT NULL,
    id           UUID         NOT NULL
        CONSTRAINT id
            PRIMARY KEY,
    avatar_url   TEXT,
    account_type account_type NOT NULL,
    status       status       NOT NULL,
    manager_id   UUID,
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
    student_id    UUID NOT NULL
        CONSTRAINT student_id
            PRIMARY KEY,
    user_id       UUID
        CONSTRAINT user_id
            REFERENCES users,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE activities
(
    activity_id SERIAL NOT NULL
        CONSTRAINT activity_id
            PRIMARY KEY,
    occur_at  VARCHAR(50),
    action      VARCHAR(100),
    resource_id        UUID,
    note        VARCHAR(100),
    activist_id     UUID,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE exams
(
    exam_id    UUID    NOT NULL
        CONSTRAINT exam_id
            PRIMARY KEY,
    questions  TEXT    NOT NULL,
    answers    TEXT    NOT NULL,
    duration   INTEGER NOT NULL,
    library_id UUID    NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    "publish" DATE    NOT NULL,
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE teachers
(
    teacher_id        UUID NOT NULL
        CONSTRAINT teacher_id
            PRIMARY KEY,
    user_id           UUID NOT NULL
        CONSTRAINT user_id
            REFERENCES users,
    educational_level TEXT,
    rating            DOUBLE PRECISION,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE assistant
(
    teacher_id   UUID NOT NULL
        CONSTRAINT teacher_id
            REFERENCES teachers,
    assistant_id UUID NOT NULL,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT assistant_id
        PRIMARY KEY (teacher_id, assistant_id)
);

CREATE TABLE libraries
(
    library_id UUID        NOT NULL
        CONSTRAINT library_id
            PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE permissions
(
    user_id     UUID
        CONSTRAINT user_id
            REFERENCES users,
    read        BOOLEAN NOT NULL,
    "create"    BOOLEAN,
    update      BOOLEAN,
    delete      BOOLEAN NOT NULL,
    resource_id UUID,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT permissions_id
        PRIMARY KEY (user_id, resource_id)
);

CREATE TABLE taking_exam
(
    student_id UUID    NOT NULL
        CONSTRAINT taking_exam_students_student_id_fk
            REFERENCES students,
    exam_id    UUID    NOT NULL
        CONSTRAINT taking_exam_exams_exam_id_fk
            REFERENCES exams,
    score      NUMERIC NOT NULL,
    ranking    NUMERIC NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT taking_id
        PRIMARY KEY (student_id, exam_id)
);

-- Down Migration
DROP TABLE IF EXISTS taking_exam;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS libraries;
DROP TABLE IF EXISTS assistant;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS status;
DROP TYPE IF EXISTS account_type;