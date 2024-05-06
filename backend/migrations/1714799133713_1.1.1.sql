-- Up Migration
CREATE OR REPLACE FUNCTION check_price_constraint()
RETURNS TRIGGER AS $$
DECLARE 
    course_price DOUBLE PRECISION;
    money_type currency_type;
BEGIN
    SELECT amount_price INTO course_price FROM courses WHERE course_id = NEW.course_id;
    SELECT currency INTO money_type FROM courses WHERE course_id = NEW.course_id;
    course_price := change_currency(course_price, money_type);
    IF NEW.current_price > course_price THEN
        RAISE EXCEPTION 'Current price cannot be greater than amount price';	
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_price_constraint_students_join_courses
BEFORE INSERT OR UPDATE ON students_join_courses
FOR EACH ROW EXECUTE FUNCTION check_price_constraint();


-- UPDATED_AT >= CREATED_AT
-- UPDATED_AT >= CREATED_AT
-- CREATE OR REPLACE FUNCTION check_time()
-- RETURNS TRIGGER AS $$
-- BEGIN
-- 	IF NEW.created_at > NEW.updated_at THEN
-- 		RAISE EXCEPTION 'Updated time ERROR: Updated time must be after created_time';
-- 	END IF;
-- 	RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER user_time_constraint
-- BEFORE INSERT OR UPDATE ON users
-- EXECUTE FUNCTION check_time();

-- CREATE TRIGGER students_time_constraint
-- BEFORE INSERT OR UPDATE ON students
-- EXECUTE FUNCTION check_time();

-- CREATE TRIGGER teacher_time_constraint
-- BEFORE INSERT OR UPDATE ON teachers
-- EXECUTE FUNCTION check_time();

-- CREATE TRIGGER review_time_constraint
-- BEFORE INSERT OR UPDATE ON reviews
-- EXECUTE FUNCTION check_time();

--
CREATE OR REPLACE FUNCTION check_account_balance() RETURNS TRIGGER AS $$
DECLARE 
    course_price DOUBLE PRECISION;
    money_type currency_type;
BEGIN
    SELECT amount_price INTO course_price FROM COURSES WHERE course_id = NEW.course_id;
    SELECT currency INTO money_type FROM COURSES WHERE course_id = NEW.course_id;
    course_price := change_currency(course_price, money_type);
    IF (SELECT account_balance FROM USERS WHERE id = NEW.student_id) < course_price THEN
        RAISE EXCEPTION 'Students can only register for new courses if their account balance is greater than or equal to the base fee of the course.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
CREATE OR REPLACE FUNCTION check_account_balance() RETURNS TRIGGER AS $$
DECLARE 
    course_price DOUBLE PRECISION;
    money_type currency_type;
BEGIN
    SELECT amount_price INTO course_price FROM COURSES WHERE course_id = NEW.course_id;
    SELECT currency INTO money_type FROM COURSES WHERE course_id = NEW.course_id;
    course_price := change_currency(course_price, money_type);
    IF (SELECT account_balance FROM USERS WHERE id = NEW.student_id) < course_price THEN
        RAISE EXCEPTION 'Students can only register for new courses if their account balance is greater than or equal to the base fee of the course.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_balance_before_register
BEFORE INSERT ON students_join_courses
FOR EACH ROW EXECUTE PROCEDURE check_account_balance();

--
CREATE OR REPLACE FUNCTION grant_view_permissions() RETURNS TRIGGER AS $$
DECLARE
    total_courses INTEGER;
    registered_courses INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_courses FROM COURSES;
    SELECT COUNT(*) INTO registered_courses FROM students_join_courses WHERE student_id = NEW.student_id;

    IF registered_courses > 0.9 * total_courses THEN
        INSERT INTO PERMISSIONS(user_id, read, resource_id)
        SELECT NEW.student_id, true, video_id FROM VIDEOS
        UNION ALL
        SELECT NEW.student_id, true, document_id FROM DOCUMENTS;
    END IF;
    IF registered_courses > 0.9 * total_courses THEN
        INSERT INTO PERMISSIONS(user_id, read, resource_id)
        SELECT NEW.student_id, true, video_id FROM VIDEOS
        UNION ALL
        SELECT NEW.student_id, true, document_id FROM DOCUMENTS;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grant_permissions_after_register
AFTER INSERT OR UPDATE ON students_join_courses
FOR EACH ROW EXECUTE PROCEDURE grant_view_permissions();

--
CREATE OR REPLACE FUNCTION revoke_view_permissions() RETURNS TRIGGER AS $$
DECLARE
    total_courses INTEGER;
    registered_courses INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_courses FROM COURSES;
    SELECT COUNT(*) INTO registered_courses FROM students_join_courses WHERE student_id = OLD.student_id;

    IF registered_courses <= 0.9 * total_courses THEN
        DELETE FROM PERMISSIONS
        WHERE user_id = OLD.student_id AND
              resource_id NOT IN (
                  SELECT resource_id
                  FROM lesson_resources
                  WHERE lesson_id IN (
                      SELECT id
                      FROM lessons
                      WHERE course_id IN (
                          SELECT course_id
                          FROM students_join_courses
                          WHERE student_id = OLD.student_id
                      )
                  )
              );
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER revoke_permissions_after_unregister
AFTER DELETE ON students_join_courses
FOR EACH ROW EXECUTE PROCEDURE revoke_view_permissions();

-- Down Migration
DROP TRIGGER IF EXISTS enforce_price_constraint_students_join_courses ON students_join_courses;
DROP FUNCTION IF EXISTS check_price_constraint;
DROP TRIGGER IF EXISTS check_balance_before_register ON students_join_courses;
DROP FUNCTION IF EXISTS check_account_balance;
DROP TRIGGER IF EXISTS grant_permissions_after_register ON students_join_courses;
DROP FUNCTION IF EXISTS grant_view_permissions;
DROP TRIGGER IF EXISTS revoke_permissions_after_unregister ON students_join_courses;
DROP FUNCTION IF EXISTS revoke_view_permissions;


CREATE TRIGGER grant_permissions_after_register
AFTER INSERT OR UPDATE ON students_join_courses
FOR EACH ROW EXECUTE PROCEDURE grant_view_permissions();

--
CREATE OR REPLACE FUNCTION revoke_view_permissions() RETURNS TRIGGER AS $$
DECLARE
    total_courses INTEGER;
    registered_courses INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_courses FROM COURSES;
    SELECT COUNT(*) INTO registered_courses FROM students_join_courses WHERE student_id = OLD.student_id;

    IF registered_courses <= 0.9 * total_courses THEN
        DELETE FROM PERMISSIONS
        WHERE user_id = OLD.student_id AND
              resource_id NOT IN (
                  SELECT resource_id
                  FROM lesson_resources
                  WHERE lesson_id IN (
                      SELECT id
                      FROM lessons
                      WHERE course_id IN (
                          SELECT course_id
                          FROM students_join_courses
                          WHERE student_id = OLD.student_id
                      )
                  )
              );
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER revoke_permissions_after_unregister
AFTER DELETE ON students_join_courses
FOR EACH ROW EXECUTE PROCEDURE revoke_view_permissions();

-- Down Migration
DROP TRIGGER IF EXISTS enforce_price_constraint_students_join_courses ON students_join_courses;
DROP FUNCTION IF EXISTS check_price_constraint;
DROP TRIGGER IF EXISTS check_balance_before_register ON students_join_courses;
DROP FUNCTION IF EXISTS check_account_balance;
DROP TRIGGER IF EXISTS grant_permissions_after_register ON students_join_courses;
DROP FUNCTION IF EXISTS grant_view_permissions;
DROP TRIGGER IF EXISTS revoke_permissions_after_unregister ON students_join_courses;
DROP FUNCTION IF EXISTS revoke_view_permissions;


