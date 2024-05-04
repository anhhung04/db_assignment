-- Up Migration
-- CREATE OR REPLACE PROCEDURE rate_course(
--     in_course_id UUID,
--     in_student_id UUID,
--     in_comment TEXT,
--     in_rating FLOAT
-- )
-- AS $$
-- DECLARE
--     student_exists BOOLEAN;
-- BEGIN
--     SELECT EXISTS (
--         SELECT *
--         FROM students_join_courses
--         WHERE student_id = in_student_id AND course_id = in_course_id
--     ) INTO student_exists;

--     IF NOT student_exists THEN
--         RAISE EXCEPTION 'Student with ID % is not enrolled in the course with ID %', in_student_id, in_course_id;
--     END IF;

--     IF in_rating < 1 OR in_rating > 5 THEN
--         RAISE EXCEPTION 'Rating must be between 1 and 5';
--     END IF;

--     INSERT INTO reviews (comment, rating, course_id, student_id)
--     VALUES (in_comment, in_rating, in_course_id, in_student_id);

--     UPDATE courses
--     SET rating = (
--         SELECT AVG(rating)
--         FROM reviews
--         WHERE course_id = in_course_id
--     )
--     WHERE course_id = in_course_id;
-- END;
-- $$ LANGUAGE plpgsql;

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


-- Down Migration