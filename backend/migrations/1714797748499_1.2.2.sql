-- -- Up Migration
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


CREATE OR REPLACE PROCEDURE change_currency(
    in_price DOUBLE PRECISION,
    in_currency currency_type
)
AS $$
DECLARE
    usd_balance DOUBLE PRECISION;
BEGIN
    IF in_currency = 'usd' THEN
        usd_balance := in_price;
    ELSIF in_currency = 'vnd' THEN
        usd_balance := in_price / 23000;
    ELSIF in_currency = 'eur' THEN
        usd_balance := in_price / 0.85;
    ELSE
        RAISE EXCEPTION 'Unsupported currency type: %', in_currency;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_review_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    student_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT *
        FROM students_join_courses
        WHERE student_id = NEW.student_id AND course_id = NEW.course_id
    ) INTO student_exists;

    IF NOT student_exists THEN
        RAISE EXCEPTION 'Student with ID % is not enrolled in the course with ID %', NEW.student_id, NEW.course_id;
    END IF;

    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        RAISE EXCEPTION 'Rating must be between 1 and 5';
    END IF;

    INSERT INTO reviews (comment, rating, course_id, student_id)
    VALUES (NEW.comment, NEW.rating, NEW.course_id, NEW.student_id);

    UPDATE courses
    SET rating = (
        SELECT AVG(rating)
        FROM reviews
        WHERE course_id = NEW.course_id
    )
    WHERE course_id = NEW.course_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_review_trigger
AFTER INSERT ON reviews
FOR EACH ROW
EXECUTE FUNCTION insert_review_trigger_function();

CREATE OR REPLACE FUNCTION update_review_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    student_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT *
        FROM students_join_courses
        WHERE student_id = NEW.student_id AND course_id = NEW.course_id
    ) INTO student_exists;

    IF NOT student_exists THEN
        RAISE EXCEPTION 'Student with ID % is not enrolled in the course with ID %', NEW.student_id, NEW.course_id;
    END IF;

    IF NEW.rating < 1 OR NEW.rating > 5 THEN
        RAISE EXCEPTION 'Rating must be between 1 and 5';
    END IF;

    UPDATE reviews
    SET comment = NEW.comment,
        rating = NEW.rating
    WHERE course_id = NEW.course_id
    AND student_id = NEW.student_id;

    UPDATE courses
    SET rating = (
        SELECT AVG(rating)
        FROM reviews
        WHERE course_id = NEW.course_id
    )
    WHERE course_id = NEW.course_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_review_trigger
AFTER UPDATE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_trigger_function();

CREATE OR REPLACE FUNCTION count_students_in_course() 
RETURNS TRIGGER AS $$
BEGIN
    UPDATE courses
    SET total_students = (
        SELECT COUNT(*)
        FROM students_join_courses
        WHERE course_id = NEW.course_id
    )
    WHERE course_id = NEW.course_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER count_students_trigger
AFTER INSERT ON students_join_courses
FOR EACH ROW EXECUTE PROCEDURE count_students_in_course();

-- CREATE OR REPLACE FUNCTION give_bonus_to_teacher() 
-- RETURNS TRIGGER AS $$
-- DECLARE
--     student_count INTEGER;
--     bonus_amount FLOAT := 100.0; 
--     threshold INTEGER := 300;
-- BEGIN
--     SELECT COUNT(*)
--     INTO student_count
--     FROM students_join_courses
--     WHERE course_id = NEW.course_id AND
--           DATE_PART('month', NEW.created_at) = DATE_PART('month', CURRENT_DATE) AND
--           DATE_PART('year', NEW.created_at) = DATE_PART('year', CURRENT_DATE);

--     IF student_count > threshold THEN
--         UPDATE users
--         SET account_balance = account_balance + bonus_amount
--         WHERE id = (
--             SELECT user_id
--             FROM teachers
--             WHERE user_id = (
--                 SELECT teacher_id
--                 FROM courses
--                 WHERE course_id = NEW.course_id
--             )
--         );
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER give_bonus_to_teacher_trigger
-- AFTER INSERT ON students_join_courses
-- FOR EACH ROW EXECUTE PROCEDURE give_bonus_to_teacher();

-- CREATE OR REPLACE FUNCTION recalculate_rating() RETURNS TRIGGER AS $$
-- BEGIN
--     UPDATE courses
--     SET rating = (
--         SELECT AVG(rating)
--         FROM reviews
--         WHERE course_id = NEW.course_id
--     )
--     WHERE course_id = NEW.course_id;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER recalculate_rating_trigger
-- AFTER INSERT ON reviews
-- FOR EACH ROW EXECUTE PROCEDURE recalculate_rating();

-- CREATE OR REPLACE FUNCTION prevent_course_deletion() 
-- RETURNS TRIGGER AS $$
-- DECLARE
--     student_count INTEGER;
-- BEGIN
--     SELECT COUNT(*)
--     INTO student_count
--     FROM students_join_courses
--     WHERE course_id = OLD.course_id;

--     IF student_count > 0 THEN
--         RAISE EXCEPTION 'Cannot delete course with ID % because it has students.', OLD.course_id;
--     END IF;

--     RETURN OLD;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER prevent_course_deletion_trigger
-- BEFORE DELETE ON courses
-- FOR EACH ROW EXECUTE PROCEDURE prevent_course_deletion();

-- CREATE OR REPLACE FUNCTION process_course_purchase() RETURNS TRIGGER AS $$
-- DECLARE
--     course_price DOUBLE PRECISION;
--     teacher_share DOUBLE PRECISION;
--     teacher_id UUID;
-- BEGIN
--     SELECT amount_price INTO course_price FROM courses WHERE course_id = NEW.course_id;
--     SELECT teacher_id INTO teacher_id FROM courses WHERE course_id = NEW.course_id;

--     course_price := change_currency(course_price, 'usd');
--     teacher_share := 0.7 * course_price;

--     UPDATE users
--     SET account_balance = account_balance + teacher_share
--     WHERE id = teacher_id;

--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER process_course_purchase_trigger
-- AFTER INSERT ON students_join_courses
-- FOR EACH ROW EXECUTE PROCEDURE process_course_purchase();

-- -- Down Migration
-- DROP TRIGGER process_course_purchase_trigger ON students_join_courses;
-- DROP FUNCTION process_course_purchase();
-- DROP TRIGGER prevent_course_deletion_trigger ON courses;
-- DROP FUNCTION prevent_course_deletion();
-- DROP TRIGGER recalculate_rating_trigger ON reviews;
-- DROP FUNCTION recalculate_rating();
-- DROP TRIGGER give_bonus_to_teacher_trigger ON students_join_courses;
-- DROP FUNCTION give_bonus_to_teacher();
-- DROP TRIGGER count_students_trigger ON students_join_courses;
-- DROP FUNCTION count_students_in_course();
-- DROP TRIGGER update_review_trigger ON reviews;
-- DROP FUNCTION update_review_trigger_function();
-- DROP TRIGGER insert_review_trigger ON reviews;
-- DROP FUNCTION insert_review_trigger_function();
-- DROP FUNCTION change_currency();
