-- -- Up Migration
-- CREATE OR REPLACE FUNCTION check_price_constraint()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF NEW.current_price > (SELECT amount_price FROM courses WHERE course_id = NEW.course_id) THEN
--         RAISE EXCEPTION 'Current price cannot be greater than amount price';	
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER enforce_price_constraint_students_join_courses
-- BEFORE INSERT OR UPDATE ON students_join_courses
-- FOR EACH ROW EXECUTE FUNCTION check_price_constraint();


-- -- UPDATED_AT >= CREATED_AT
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

-- --
-- CREATE OR REPLACE FUNCTION check_student_account() RETURNS TRIGGER AS $$
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM users WHERE id = NEW.user_id) THEN
--         RAISE EXCEPTION 'Students must have an account before purchasing a course.';
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER student_account_trigger
-- BEFORE INSERT OR UPDATE ON students
-- FOR EACH ROW EXECUTE PROCEDURE check_student_account();

-- -- CREATE OR REPLACE FUNCTION check_account_balance() RETURNS TRIGGER AS $$
-- -- BEGIN
-- --     IF (SELECT account_balance FROM USERS WHERE id = NEW.user_id) < (SELECT amount_price FROM COURSES WHERE course_id = NEW.course_id) THEN
-- --         RAISE EXCEPTION 'Students can only register for new courses if their account balance is greater than or equal to the base fee of the course.';
-- --     END IF;
-- --     RETURN NEW;
-- -- END;
-- -- $$ LANGUAGE plpgsql;

-- -- CREATE TRIGGER check_balance_before_register
-- -- BEFORE INSERT ON STUDENTS
-- -- FOR EACH ROW EXECUTE PROCEDURE check_account_balance();

-- CREATE OR REPLACE FUNCTION grant_view_permissions() RETURNS TRIGGER AS $$
-- DECLARE
--     total_courses INTEGER;
--     registered_courses INTEGER;
-- BEGIN
--     SELECT COUNT(*) INTO total_courses FROM COURSES;
--     SELECT COUNT(*) INTO registered_courses FROM STUDENTS WHERE student_id = NEW.user_id;

--     IF registered_courses > 0.9 * total_courses THEN
--         INSERT INTO PERMISSIONS(user_id, read, resource_id)
--         SELECT NEW.user_id, true, video_id FROM VIDEOS
--         UNION ALL
--         SELECT NEW.user_id, true, document_id FROM DOCUMENTS;
--     END IF;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER grant_permissions_after_register
-- AFTER INSERT OR UPDATE ON STUDENTS
-- FOR EACH ROW EXECUTE PROCEDURE grant_view_permissions();
-- -- Down Migration
-- DROP FUNCTION check_price_constraint();
-- DROP TRIGGER enforce_price_constraint_students_join_courses;
-- DROP FUNCTION check_time();
-- DROP TRIGGER user_time_constraint;
-- DROP TRIGGER students_time_constraint;
-- DROP TRIGGER teacher_time_constraint;
-- DROP TRIGGER review_time_constraint;
-- DROP FUNCTION check_student_account();
-- DROP TRIGGER student_account_trigger;
-- DROP FUNCTION add_to_participate();
-- DROP TRIGGER add_student_to_participate;
-- DROP FUNCTION check_account_balance();
-- DROP TRIGGER check_balance_before_register;
-- DROP FUNCTION grant_view_permissions();
-- DROP TRIGGER grant_permissions_after_register;
