-- Up Migration
CREATE TABLE courses
(
    course_id   UUID NOT NULL
        CONSTRAINT course_pk
            PRIMARY KEY,
    title        VARCHAR(100) CHECK (LENGTH(title) > 10 AND LENGTH(title) <= 100) NOT NULL,
    type        course_type,
    description VARCHAR(200),
    rating FLOAT CHECK (rating >= 0 AND rating <= 5) NOT NULL DEFAULT 0,
    level       VARCHAR(20),
    thumbnail_url TEXT,
    headline   VARCHAR(100)  ,
    content_info VARCHAR(50) NOT NULL,
    amount_price DOUBLE PRECISION NOT NULL,
    currency currency_type NOT NULL,
    course_slug VARCHAR(100) NOT NULL UNIQUE,
    access_count integer NOT NULL DEFAULT 0,
    total_students integer NOT NULL DEFAULT 0,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at  TIMESTAMP DEFAULT NOW() NOT NULL
);

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

CREATE TABLE lessons
(
    id          UUID                    NOT NULL
        CONSTRAINT lessons_pk
            PRIMARY KEY,
    description TEXT,
    title       VARCHAR(100)            NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    course_id    UUID
        CONSTRAINT lessons_courses_course_id_fk
            REFERENCES courses
            ON DELETE CASCADE
);

 CREATE TABLE learning_resources
(
    id           UUID         NOT NULL
        CONSTRAINT learning_resource_pk
            PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    download_url VARCHAR(200)
);

CREATE TABLE documents
(
    id           UUID NOT NULL
        CONSTRAINT documents_pk
            PRIMARY KEY
        CONSTRAINT documents_learning_resource_id_fk
            REFERENCES learning_resources
            ON DELETE CASCADE,
    material     VARCHAR(200),
    author       VARCHAR(50),
    format       VARCHAR(50),
    type         document_type
    -- course_id    UUID
    --     CONSTRAINT documents_course_course_id_fk
    --         REFERENCES courses
    --         ON DELETE CASCADE
);


CREATE TABLE videos
(
    id          UUID NOT NULL
        CONSTRAINT video_id
            PRIMARY KEY
        CONSTRAINT videos_learning_resource_id_fk
            REFERENCES learning_resources
            ON DELETE CASCADE,
    description       TEXT,
    duration          INTEGER DEFAULT 0
    -- course_id         UUID
    --     CONSTRAINT videos_course_id_fk
    --         REFERENCES courses
    --         ON DELETE CASCADE
);

CREATE TABLE lesson_resources
(
    lesson_id     UUID NOT NULL
        CONSTRAINT lesson_resource_lessons_id_fk
            REFERENCES lessons
            ON DELETE CASCADE,
    resource_id   UUID NOT NULL
        CONSTRAINT lesson_resources_learning_resources_id_fk
            REFERENCES learning_resources
            ON DELETE CASCADE,
    resource_type resource_type,
    CONSTRAINT lesson_resource_pk
        PRIMARY KEY (lesson_id, resource_id)
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
-- DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS lesson_resources;
DROP TABLE IF EXISTS learning_resources;
