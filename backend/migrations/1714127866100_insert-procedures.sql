-- Up Migration
CREATE OR REPLACE PROCEDURE display_user_names()
AS $$
BEGIN
    UPDATE users SET display_name = CONCAT(lname, ' ', fname)
    WHERE display_name IS NULL OR display_name = '';
END;
$$ LANGUAGE plpgsql;
--CALL display_user_names();

CREATE OR REPLACE PROCEDURE rate_course(
    in_course_id UUID,
    in_student_id UUID,
    in_comment TEXT,
    in_rating FLOAT
)
AS $$
BEGIN
    INSERT INTO reviews (comment, rating, course_id, student_id)
    VALUES (in_comment, in_rating, in_course_id, in_student_id);

    -- update total number of students
    UPDATE courses
    SET total_students = total_students + 1
    WHERE course_id = in_course_id;

    -- update average rating for courses
    UPDATE courses
    SET rating = (
        SELECT AVG(rating)
        FROM reviews
        WHERE course_id = in_course_id
    )
    WHERE course_id = in_course_id;
END;
$$ LANGUAGE plpgsql;

-- Down Migration