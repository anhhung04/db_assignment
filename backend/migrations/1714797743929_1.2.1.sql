-- Up Migration
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE OR REPLACE PROCEDURE check_password(in_password VARCHAR(100))
AS $$
BEGIN
    IF LENGTH(in_password) < 5 THEN
        RAISE EXCEPTION 'Password must be at least 5 characters long.';
    END IF;

    IF NOT (in_password ~'^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$') THEN
        RAISE EXCEPTION 'Invalid password format';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE check_valid_email(in_email TEXT)
AS $$
BEGIN
    IF NOT (in_email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        RAISE EXCEPTION 'Invalid email format.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE check_valid_phone_no(in_phone_no VARCHAR(11))
AS $$
BEGIN
    IF NOT (in_phone_no ~ '^[0-9]{10,11}$') THEN
        RAISE EXCEPTION 'Invalid phone number format.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE check_valid_birthday(in_birthday DATE, in_account_type account_type)
AS $$
DECLARE
    v_age INTEGER;
BEGIN
    v_age := EXTRACT(YEAR FROM AGE(in_birthday));

    IF in_account_type = 'teacher' AND v_age < 18 THEN
        RAISE EXCEPTION 'Teachers must be at least 18 years old.';
    ELSIF v_age < 11 THEN
        RAISE EXCEPTION 'Users must be at least 11 years old.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE check_valid_url(in_url TEXT)
AS $$
DECLARE
    v_error_message VARCHAR;
BEGIN
    IF NOT (in_url ~ '^(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?\/[a-zA-Z0-9]{2,}|((https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z]{2,}(\.[a-zA-Z]{2,})(\.[a-zA-Z]{2,})?)|(https:\/\/www\.|http:\/\/www\.|https:\/\/|http:\/\/)?[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}\.[a-zA-Z0-9]{2,}(\.[a-zA-Z0-9]{2,})?') THEN
        RAISE EXCEPTION 'Invalid url format';
    END IF;
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
    in_phone_no VARCHAR(11),
    in_birthday DATE
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
    v_error_message VARCHAR;
BEGIN 
    IF in_username IS NULL THEN
        v_error_message := 'Username is required.';
        RAISE EXCEPTION '%', v_error_message;
    END IF;
	IF in_username IN (SELECT username FROM users) THEN
		v_error_message := 'Username existed. Enter another username';
		RAISE EXCEPTION '%', v_error_message;
	END IF;
    IF in_password IS NULL THEN
        v_error_message := 'Password is required.';
        RAISE EXCEPTION '%', v_error_message;
    END IF;
    CALL check_password(in_password);
	
    IF in_email IS NULL THEN
        v_error_message := 'Email is required.';
        RAISE EXCEPTION '%', v_error_message;
    END IF;
    CALL check_valid_email(in_email);

    IF in_phone_no IS NULL THEN
        v_error_message := 'Phone number is required.';
        RAISE EXCEPTION '%', v_error_message;
    END IF;
    CALL check_valid_phone_no(in_phone_no);

    IF in_birthday IS NULL THEN
        v_error_message := 'Birthday is required.';
        RAISE EXCEPTION '%', v_error_message;
    END IF;
    CALL check_valid_birthday(in_birthday, in_account_type);
    CALL check_valid_url(in_avatar_url);

    INSERT INTO users (id, username, password, fname, lname, email, address, avatar_url, account_type, phone_no, birthday)
    VALUES (in_id, in_username, in_password, in_fname, in_lname, in_email, in_address, in_avatar_url, in_account_type, in_phone_no, in_birthday);
    INSERT INTO permissions(user_id, read, "create", update, delete)
    VALUES (in_id, FALSE, FALSE, FALSE, FALSE);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_user(in_id UUID)
AS $$
BEGIN
    DELETE FROM users WHERE id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_user(
    in_id UUID,
    in_username TEXT,
    in_password VARCHAR(100),
    in_fname VARCHAR(100),
    in_lname VARCHAR(100),
    in_email VARCHAR(100),
    in_address TEXT,
    in_avatar_url TEXT,
    in_account_type account_type,
    in_phone_no VARCHAR(11),
    in_birthday DATE
)
AS $$
BEGIN
    IF in_password IS NOT NULL AND in_password != '' THEN
        CALL check_password(in_password);
    END IF;
    IF in_email IS NOT NULL AND in_email != '' THEN
        CALL check_valid_email(in_email);
    END IF;
    IF in_phone_no IS NOT NULL AND in_phone_no != '' THEN
        CALL check_valid_phone_no(in_phone_no);
    END IF;
    IF in_birthday IS NOT NULL THEN
        CALL check_valid_birthday(in_birthday, in_account_type);
    END IF;
    IF in_avatar_url IS NOT NULL AND in_avatar_url != '' THEN
        CALL check_valid_url(in_avatar_url);
    END IF;

    UPDATE users
    SET username = CASE WHEN in_username IS NOT NULL AND in_username != '' THEN in_username ELSE username END,
        password = CASE WHEN in_password IS NOT NULL AND in_password != '' THEN in_password ELSE password END,
        fname = CASE WHEN in_fname IS NOT NULL AND in_fname != '' THEN in_fname ELSE fname END,
        lname = CASE WHEN in_lname IS NOT NULL AND in_lname != '' THEN in_lname ELSE lname END,
        email = CASE WHEN in_email IS NOT NULL AND in_email != '' THEN in_email ELSE email END,
        address = CASE WHEN in_address IS NOT NULL AND in_address != '' THEN in_address ELSE address END,
        avatar_url = CASE WHEN in_avatar_url IS NOT NULL AND in_avatar_url != '' THEN in_avatar_url ELSE avatar_url END,
        account_type = CASE WHEN in_account_type IS NOT NULL THEN in_account_type ELSE account_type END,
        phone_no = CASE WHEN in_phone_no IS NOT NULL AND in_phone_no != '' THEN in_phone_no ELSE phone_no END,
        birthday = CASE WHEN in_birthday IS NOT NULL THEN in_birthday ELSE birthday END
    WHERE id = in_id;
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
    in_phone_no VARCHAR(11),
    in_birthday DATE
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN 
CALL insert_user(
    in_username,
    in_password,
    in_fname,
    in_lname,
    in_email,
    in_address,
    in_avatar_url,
    "student",
    in_phone_no,
    in_birthday
);
    INSERT INTO students (english_level, study_history, target, user_id)
    VALUES (in_english_level, in_study_history, in_target, in_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_student(in_id UUID)
AS $$
BEGIN
    DELETE FROM students WHERE user_id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_student(
    in_id UUID,
    in_english_level VARCHAR(50),
    in_study_history VARCHAR(150),
    in_target VARCHAR(30)
)
AS $$
BEGIN
    UPDATE students
    SET english_level = CASE WHEN in_english_level IS NOT NULL AND in_english_level != '' THEN in_english_level ELSE english_level END,
        study_history = CASE WHEN in_study_history IS NOT NULL AND in_study_history != '' THEN in_study_history ELSE study_history END,
        target = CASE WHEN in_target IS NOT NULL AND in_target != '' THEN in_target ELSE target END
    WHERE user_id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_teacher(
    in_educational_level VARCHAR(150),
    in_username TEXT,
    in_password VARCHAR(100),
    in_fname VARCHAR(100),
    in_lname VARCHAR(100),
    in_email VARCHAR(100),
    in_address TEXT,
in_avatar_url TEXT,
    in_phone_no VARCHAR(11),
    in_birthday DATE,
    in_rating DOUBLE PRECISION DEFAULT 0
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN
CALL insert_user(
    in_username,
    in_password,
    in_fname,
    in_lname,
    in_email,
    in_address,
    in_avatar_url,
    "teacher",
    in_phone_no,
    in_birthday
);
    INSERT INTO teachers (user_id, educational_level, rating)
    VALUES (in_id, in_educational_level, in_rating);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_teacher(in_id UUID)
AS $$
BEGIN
    DELETE FROM teachers WHERE user_id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_teacher(
    in_id UUID,
    in_educational_level VARCHAR(150),
    in_rating DOUBLE PRECISION
)
AS $$
BEGIN
    UPDATE teachers
    SET educational_level = CASE WHEN in_educational_level IS NOT NULL AND in_educational_level != '' THEN in_educational_level ELSE educational_level END,
        rating = CASE WHEN in_rating IS NOT NULL THEN in_rating ELSE rating END
    WHERE user_id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_courses(
    in_title VARCHAR(100),
    in_type course_type,
    in_description VARCHAR(200),
    in_level VARCHAR(20),
    in_thumbnail_url TEXT,
    in_headline VARCHAR(100),
    in_content_info VARCHAR(50),
    in_amount_price DOUBLE PRECISION,
    in_currency currency_type,
    in_course_slug VARCHAR(100),
    in_access_count INTEGER DEFAULT 0,
    in_total_students INTEGER DEFAULT 0,
    in_rating DOUBLE PRECISION DEFAULT 0
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN
    IF in_title IS NULL THEN
        RAISE EXCEPTION 'Title is required.';
    END IF;
    IF in_description IS NULL THEN
        RAISE EXCEPTION 'Description is required.';
    END IF;
    IF in_level IS NULL THEN
        RAISE EXCEPTION 'Level is required.';
    END IF;
    IF in_content_info IS NULL THEN
        RAISE EXCEPTION 'Content info is required.';
    END IF;
    IF in_amount_price IS NULL THEN
        RAISE EXCEPTION 'Amount price is required.';
    END IF;
    IF in_currency IS NULL THEN
        RAISE EXCEPTION 'Currency is required.';
    END IF;
    CALL check_valid_url(in_thumbnail_url);
    INSERT INTO courses (course_id, title, type, description, rating, level, thumbnail_url, headline, content_info, amount_price, currency, course_slug, access_count, total_students)
VALUES (
        in_id,
        in_title,
        in_type,
        in_description,
        in_rating,
        in_level,
        in_thumbnail_url,
        in_headline,
        in_content_info,
        in_amount_price,
        in_currency,
        in_course_slug,
        in_access_count,
        in_total_students
);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_courses(in_id UUID)
AS $$
BEGIN
    DELETE FROM courses WHERE course_id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_courses(
    in_id UUID,
    in_description VARCHAR(200),
    in_level VARCHAR(20),
    in_thumbnail_url TEXT,
    in_headline VARCHAR(100),
    in_content_info VARCHAR(50),
    in_amount_price DOUBLE PRECISION,
    in_currency currency_type
)
AS $$
BEGIN
    IF in_thumbnail_url IS NOT NULL AND in_thumbnail_url != '' THEN
        CALL check_valid_url(in_thumbnail_url);
    END IF;

    UPDATE courses
    SET description = CASE WHEN in_description IS NOT NULL AND in_description != '' THEN in_description ELSE description END,
        level = CASE WHEN in_level IS NOT NULL AND in_level != '' THEN in_level ELSE level END,
        thumbnail_url = CASE WHEN in_thumbnail_url IS NOT NULL AND in_thumbnail_url != '' THEN in_thumbnail_url ELSE thumbnail_url END,
        headline = CASE WHEN in_headline IS NOT NULL AND in_headline != '' THEN in_headline ELSE headline END,
        content_info = CASE WHEN in_content_info IS NOT NULL AND in_content_info != '' THEN in_content_info ELSE content_info END,
        amount_price = CASE WHEN in_amount_price IS NOT NULL THEN in_amount_price ELSE amount_price END,
        currency = CASE WHEN in_currency IS NOT NULL THEN in_currency ELSE currency END
    WHERE course_id = in_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insert_lessons(
    in_title VARCHAR(100),
    in_description TEXT,
    in_course_id UUID
)
AS $$
DECLARE
    in_id UUID := uuid_generate_v4();
BEGIN
    INSERT INTO lessons (id, title, description, course_id)
    VALUES (in_id, in_title, in_description, in_course_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_lessons(in_id UUID)
AS $$
DECLARE
    course_id UUID;
BEGIN
    SELECT course_id INTO course_id FROM lessons WHERE id = in_id;
    DELETE FROM lessons WHERE id = in_id;
    IF NOT EXISTS (SELECT 1 FROM lessons WHERE course_id = course_id) THEN
        DELETE FROM courses WHERE id = course_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE update_lessons(
    in_id UUID,
    in_title VARCHAR(100),
    in_description TEXT,
    in_course_id UUID
)
AS $$
BEGIN
    UPDATE lessons
    SET title = CASE WHEN in_title IS NOT NULL AND in_title != '' THEN in_title ELSE title END,
        description = CASE WHEN in_description IS NOT NULL AND in_description != '' THEN in_description ELSE description END,
        course_id = CASE WHEN in_course_id IS NOT NULL THEN in_course_id ELSE course_id END
    WHERE id = in_id;
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE PROCEDURE insert_student_into_course(
--     in_student_id UUID,
--     in_course_id UUID
-- )
-- AS $$
-- BEGIN
--     INSERT INTO students_join_courses (student_id, course_id)
--     VALUES (in_student_id, in_course_id);
-- END;
-- $$ LANGUAGE plpgsql;

-- Down Migration
DROP PROCEDURE IF EXISTS check_password;
DROP PROCEDURE IF EXISTS check_valid_email;
DROP PROCEDURE IF EXISTS check_valid_phone_no;
DROP PROCEDURE IF EXISTS check_valid_birthday;
DROP PROCEDURE IF EXISTS check_valid_url;
DROP PROCEDURE IF EXISTS insert_user;
DROP PROCEDURE IF EXISTS delete_user;
DROP PROCEDURE IF EXISTS update_user;
DROP PROCEDURE IF EXISTS insert_student;
DROP PROCEDURE IF EXISTS delete_student;
DROP PROCEDURE IF EXISTS update_student;
DROP PROCEDURE IF EXISTS insert_teacher;
DROP PROCEDURE IF EXISTS delete_teacher;
DROP PROCEDURE IF EXISTS update_teacher;
DROP PROCEDURE IF EXISTS insert_courses;
DROP PROCEDURE IF EXISTS delete_courses;
DROP PROCEDURE IF EXISTS update_courses;
DROP PROCEDURE IF EXISTS insert_lessons;
DROP PROCEDURE IF EXISTS delete_lessons;
DROP PROCEDURE IF EXISTS update_lessons;
DROP PROCEDURE IF EXISTS insert_student_into_course;