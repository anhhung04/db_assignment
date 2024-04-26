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

-- Down Migration
-- DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS students_join_courses;
