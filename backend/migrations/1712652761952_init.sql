-- Up Migration
CREATE TYPE account_type AS ENUM ('operator', 'teacher', 'student');

ALTER TYPE account_type OWNER TO dev_user;

CREATE TYPE status AS ENUM ('active', 'inactive');

ALTER TYPE status OWNER TO dev_user;

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
    created_at   TIMESTAMP,
    updated_at   TIMESTAMP
);

ALTER TABLE users
    OWNER TO dev_user;

CREATE TABLE students
(
    english_level VARCHAR(50),
    study_history VARCHAR(150),
    target        VARCHAR(15),
    student_id    UUID NOT NULL
        CONSTRAINT student_id
            PRIMARY KEY,
    user_id       UUID
        CONSTRAINT user_id
            REFERENCES users,
    created_at    TIMESTAMP,
    updated_at    TIMESTAMP
);

ALTER TABLE students
    OWNER TO dev_user;

CREATE TABLE activities
(
    activity_id UUID NOT NULL
        CONSTRAINT activity_id
            PRIMARY KEY,
    occur_at    TIMESTAMP,
    created_by  VARCHAR(50),
    action      VARCHAR(50),
    dest        VARCHAR(50),
    note        VARCHAR(100),
    user_id     UUID
        CONSTRAINT user_id
            REFERENCES users,
    created_at  TIMESTAMP,
    updated_at  TIMESTAMP
);

ALTER TABLE activities
    OWNER TO dev_user;

CREATE TABLE exams
(
    exam_id    UUID    NOT NULL
        CONSTRAINT exam_id
            PRIMARY KEY,
    questions  TEXT    NOT NULL,
    answers    TEXT    NOT NULL,
    duration   INTEGER NOT NULL,
    library_id UUID    NOT NULL,
    create_at  TIMESTAMP,
    "publish " DATE    NOT NULL,
    update_at  TIMESTAMP
);

ALTER TABLE exams
    OWNER TO dev_user;

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
    created_at        TIMESTAMP,
    updated_at        TIMESTAMP
);

ALTER TABLE teachers
    OWNER TO dev_user;

CREATE TABLE assistant
(
    teacher_id   UUID NOT NULL
        CONSTRAINT teacher_id
            REFERENCES teachers,
    assistant_id UUID NOT NULL,
    created_at   TIMESTAMP,
    updated_at   TIMESTAMP,
    CONSTRAINT assistant_id
        PRIMARY KEY (teacher_id, assistant_id)
);

ALTER TABLE assistant
    OWNER TO dev_user;

CREATE TABLE libraries
(
    library_id UUID        NOT NULL
        CONSTRAINT library_id
            PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    create_at  TIMESTAMP,
    update_at  TIMESTAMP
);

ALTER TABLE libraries
    OWNER TO dev_user;

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
    create_at   TIMESTAMP,
    update_at   TIMESTAMP
);

ALTER TABLE permissions
    OWNER TO dev_user;

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
    create_at  TIMESTAMP,
    update_at  TIMESTAMP,
    CONSTRAINT taking_id
        PRIMARY KEY (student_id, exam_id)
);

ALTER TABLE taking_exam
    OWNER TO dev_user;

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