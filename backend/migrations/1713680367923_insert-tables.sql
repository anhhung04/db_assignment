-- Up Migration
CREATE TYPE course_type AS ENUM ('ielts', 'toeic', 'communicate');
CREATE TYPE document_type AS ENUM ('book', 'dictionary', 'mock_test');
CREATE TYPE ebook_type AS ENUM ('theory', 'practical');
CREATE TYPE currency_type AS ENUM ('usd', 'vnd', 'eur');
CREATE TYPE level_type AS ENUM ('A1', 'A2', 'B1', 'B2', 'C1', 'C2');

CREATE TABLE courses
(
    course_id   UUID NOT NULL
        CONSTRAINT course_pk
            PRIMARY KEY,
    title        VARCHAR(50),
    type        course_type,
    description VARCHAR(200),
    rating      DOUBLE PRECISION,
    price    DECIMAL,
    level       level_type,
    thumbnail_url TEXT,
    headline   VARCHAR(100)  ,
    content_info VARCHAR(20) NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    currency currency_type NOT NULL,
    title_slug VARCHAR(100) NOT NULL UNIQUE,
    total_students integer NOT NULL DEFAULT 0,
);

-- ALTER TABLE exams
--     ADD CONSTRAINT exams_course_id_fk
--         FOREIGN KEY (course_id)
--             REFERENCES courses
--             ON DELETE CASCADE;

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
    title        VARCHAR(200),
    material     VARCHAR(200),
    author       VARCHAR(50),
    format       VARCHAR(50),s
    type         document_type,
    download_uri VARCHAR(200),
    course_id    UUID
        CONSTRAINT documents_course_course_id_fk
            REFERENCES courses
            ON DELETE CASCADE
);


CREATE TABLE videos
(
    video_id          UUID NOT NULL
        CONSTRAINT video_id
            PRIMARY KEY,
    title             VARCHAR(150),
    description       TEXT,
    duration          INTEGER DEFAULT 0,
    download_resource VARCHAR(200),
    course_id         UUID
        CONSTRAINT videos_course_id_fk
            REFERENCES courses
            ON DELETE CASCADE
);


-- CREATE TABLE ebooks
-- (
--     book_id    UUID NOT NULL,
--     price      DOUBLE PRECISION,
--     title      VARCHAR,
--     version    VARCHAR,
--     course_id UUID
--         CONSTRAINT ebooks_course_id_fk
--             REFERENCES courses
--             ON DELETE CASCADE,
--     type       ebook_type
-- );

-- Down Migration
-- DROP TABLE IF EXISTS ebooks;
DROP TABLE IF EXISTS videos;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS courses;

DROP TYPE IF EXISTS ebook_type;
DROP TYPE IF EXISTS document_type;
DROP TYPE IF EXISTS course_type;