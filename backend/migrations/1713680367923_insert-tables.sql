-- Up Migration
CREATE TYPE course_type AS ENUM ('ielts', 'toeic', 'communicate');
CREATE TYPE document_type AS ENUM ('book', 'dictionary', 'mock_test');
CREATE TYPE ebook_type AS ENUM ('theory', 'practical');

CREATE TABLE courses

(
    course_id   UUID NOT NULL
        CONSTRAINT course_id
            PRIMARY KEY,
    name        VARCHAR(50),
    type        course_type,
    description VARCHAR(200),
    rating      DOUBLE PRECISION,
    base_fee    DOUBLE PRECISION,
    level       INTEGER
);

ALTER TABLE exams
    ADD CONSTRAINT exams_course_id_fk
        FOREIGN KEY (course_id)
            REFERENCES courses
            ON DELETE CASCADE
            ON UPDATE CASCADE;

-- CREATE TABLE classes
-- (
--     class_id   UUID NOT NULL
--         CONSTRAINT classes_pk
--             PRIMARY KEY,
--     course_id  UUID
--         CONSTRAINT classes_course_course_id_fk
--             REFERENCES courses
--             ON UPDATE CASCADE ON DELETE CASCADE,
--     schedule   VARCHAR(200),
--     teacher_id UUID
-- );

CREATE TABLE documents
(
    id           UUID NOT NULL
        CONSTRAINT documents_pk
            PRIMARY KEY,
    title        VARCHAR(50),
    material     VARCHAR(200),
    author       VARCHAR(50),
    format       VARCHAR(50),
    type         document_type,
    download_uri VARCHAR(100),
    course_id    UUID
        CONSTRAINT documents_course_course_id_fk
            REFERENCES courses
            ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE videos
(
    video_id          UUID NOT NULL
        CONSTRAINT video_id
            PRIMARY KEY,
    title             VARCHAR,
    description       VARCHAR,
    timeline          VARCHAR,
    duration          VARCHAR,
    download_resource VARCHAR,
    course_id         UUID
        CONSTRAINT videos_course_id_fk
            REFERENCES courses
            ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE ebooks
(
    book_id    UUID NOT NULL,
    price      DOUBLE PRECISION,
    title      VARCHAR,
    version    VARCHAR,
    library_id UUID,
    type       ebook_type
);

-- Down Migration
DROP TABLE IF EXISTS ebooks;
DROP TABLE IF EXISTS videos;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS courses;

DROP TYPE IF EXISTS ebook_type;
DROP TYPE IF EXISTS document_type;
DROP TYPE IF EXISTS course_type;