-- Up Migration
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE OR REPLACE PROCEDURE rate_course(
    in_course_id UUID,
    in_student_id UUID,
    in_comment TEXT,
    in_rating FLOAT
)
AS $$
DECLARE
    student_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT *
        FROM students_join_courses
        WHERE student_id = in_student_id AND course_id = in_course_id
    ) INTO student_exists;

    IF NOT student_exists THEN
        RAISE EXCEPTION 'Student with ID % is not enrolled in the course with ID %', in_student_id, in_course_id;
    END IF;

    IF in_rating < 1 OR in_rating > 5 THEN
        RAISE EXCEPTION 'Rating must be between 1 and 5';
    END IF;

    INSERT INTO reviews (comment, rating, course_id, student_id)
    VALUES (in_comment, in_rating, in_course_id, in_student_id);

    UPDATE courses
    SET rating = (
        SELECT AVG(rating)
        FROM reviews
        WHERE course_id = in_course_id
    )
    WHERE course_id = in_course_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_user(
    in_username TEXT,
    in_password VARCHAR(100),
    in_fname VARCHAR(100),
    in_lname VARCHAR(100),
    in_email VARCHAR(100),
    in_address TEXT,
    in_avatar_url TEXT,
    in_account_type account_type,
    in_status status,
    in_phone_no VARCHAR(11),
    in_birthday DATE
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN
    INSERT INTO users (id, username, password, fname, lname, email, address, avatar_url, account_type, status, phone_no, birthday)
    VALUES (in_id, in_username, in_password, in_fname, in_ljsoname, in_email, in_address, in_avatar_url, in_account_type, in_status, in_phone_no, in_birthday);
    INSERT INTO permissions(user_id, read, "create", update, delete)
    VALUES (in_id, FALSE, FALSE, FALSE, FALSE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_student(
    in_english_level VARCHAR(50),
    in_study_history VARCHAR(150),
    in_target VARCHAR(30),
    in_username TEXT,
    in_password VARCHAR(100),
    in_fname VARCHAR(100),
    in_lname VARCHAR(100),
    in_email VARCHAR(100),
    in_address TEXT,
    in_avatar_url TEXT,
    in_account_type account_type,
    in_status status,
    in_phone_no VARCHAR(11),
    in_birthday DATE
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN 
    INSERT INTO users (id, username, password, fname, lname, email, address, avatar_url, account_type, status, phone_no, birthday)
    VALUES (in_id, in_username, in_password, in_fname, in_ljsoname, in_email, in_address, in_avatar_url, in_account_type, in_status, in_phone_no, in_birthday);
    INSERT INTO students (english_level, study_history, target, user_id)
    VALUES (in_english_level, in_study_history, in_target, in_id);
    INSERT INTO permissions(user_id, read, "create", update, delete)
    VALUES (in_id, FALSE, FALSE, FALSE, FALSE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_teacher(
    in_username TEXT,
    in_password VARCHAR(100),
    in_fname VARCHAR(100),
    in_lname VARCHAR(100),
    in_email VARCHAR(100),
    in_address TEXT,
    in_avatar_url TEXT,
    in_account_type account_type,
    in_status status,
    in_phone_no VARCHAR(11),
    in_birthday DATE
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN
    INSERT INTO users (id, username, password, fname, lname, email, address, avatar_url, account_type, status, phone_no, birthday)
    VALUES (in_id, in_username, in_password, in_fname, in_lname, in_email, in_address, in_avatar_url, in_account_type, in_status, in_phone_no, in_birthday);
    INSERT INTO permissions(user_id, read, "create", update, delete)
    VALUES (in_id, FALSE, FALSE, FALSE, FALSE);
END;
$$ LANGUAGE plpgsql;



-- Down Migration