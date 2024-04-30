-- Up Migration
CREATE OR REPLACE FUNCTION get_top_highlight_courses()
RETURNS TABLE (
    course_id UUID,
    title VARCHAR(50),
    rating DOUBLE PRECISION,
    total_students INT,
    recent_students BIGINT,
    access_times INT,
    total_reviews BIGINT,
    avg_review DOUBLE PRECISION
) AS $$
DECLARE
    limit_count INT := 5;
    recent_days INT := 30;
BEGIN
    RETURN QUERY
    SELECT
        c.course_id,
        c.title,
        c.rating,
        c.total_students,
        COUNT(DISTINCT sjc.student_id) AS recent_students,
        c.access_times,
        COUNT(r.id) AS total_reviews,
        COALESCE(AVG(r.rating), 0) AS avg_review
    FROM
        courses c
    LEFT JOIN
        reviews r ON c.course_id = r.course_id
    LEFT JOIN
        students_join_courses sjc ON c.course_id = sjc.course_id AND sjc.created_at > NOW() - INTERVAL '1 day' * recent_days
    GROUP BY
        c.course_id, c.title, c.rating, c.total_students, c.access_times
    ORDER BY
        recent_students DESC,
        c.total_students DESC,
        c.rating DESC,
        c.access_times DESC,
        total_reviews DESC,
        avg_review DESC
    LIMIT
        limit_count;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_current_price(student_id UUID, course_id UUID)
RETURNS NUMERIC AS $$
DECLARE
    original_price NUMERIC;
    num_courses INTEGER;
    discount NUMERIC;
    current_price NUMERIC;
BEGIN
    SELECT price INTO original_price FROM courses WHERE course_id = course_id;

    SELECT COUNT(*) INTO num_courses FROM students_join_courses WHERE student_id = student_id;

    IF num_courses BETWEEN 3 AND 5 THEN
        discount := 0.10;
    ELSIF num_courses BETWEEN 6 AND 10 THEN
        discount := 0.20;
    ELSIF num_courses > 10 THEN
        discount := 0.30;
    ELSE
        discount := 0.00;
    END IF;
    current_price := original_price * (1 - discount);

    RETURN current_price;
END;
$$ LANGUAGE plpgsql;

-- Down Migration
DROP IF EXISTS FUNCTION get_top_highlight_courses();
DROP IF EXISTS FUNCTION calculate_current_price();