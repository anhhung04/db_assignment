-- Up Migration
CREATE OR REPLACE FUNCTION get_top_highlight_courses(min_avg_review DOUBLE PRECISION, limit_count INT)
RETURNS TABLE (
    course_id UUID,
    title VARCHAR(50),
    rating DOUBLE PRECISION,
    total_students INT,
    recent_students BIGINT,
    access_count INT,
    total_reviews BIGINT,
    avg_review DOUBLE PRECISION
) AS $$
DECLARE
    recent_days INT := 30;
    course_count INT;
BEGIN
    CREATE TEMP TABLE recent_courses ON COMMIT DROP AS
    SELECT course_id
    FROM students_join_courses
    WHERE created_at > NOW() - INTERVAL '1 day' * recent_days
    GROUP BY course_id;

    SELECT COUNT(*) INTO course_count FROM recent_courses;

    WHILE course_count < 5 AND recent_days < 90 LOOP
        recent_days := recent_days + 30;

        INSERT INTO recent_courses
        SELECT course_id
        FROM students_join_courses
        WHERE created_at > NOW() - INTERVAL '1 day' * recent_days
        GROUP BY course_id;

        SELECT COUNT(*) INTO course_count FROM recent_courses;
    END LOOP;

    RETURN QUERY
    SELECT
        c.course_id,
        c.title,
        c.rating,
        c.total_students,
        (SELECT COUNT(DISTINCT student_id) FROM students_join_courses WHERE course_id = c.course_id AND created_at > NOW() - INTERVAL '1 month') AS recent_students,
        c.access_count,
        COUNT(r.id) AS total_reviews,
        COALESCE(AVG(r.rating), 0) AS avg_review
    FROM
        courses c
    JOIN
        recent_courses rc ON c.course_id = rc.course_id
    LEFT JOIN
        reviews r ON c.course_id = r.course_id
    GROUP BY
        c.course_id, c.title, c.rating, c.total_students, c.access_count
    HAVING
        COALESCE(AVG(r.rating), 0) > min_avg_review
    ORDER BY
        recent_students DESC,
        c.total_students DESC,
        c.rating DESC,
        c.access_count DESC,
        total_reviews DESC,
        avg_review DESC
    LIMIT
        limit_count;
END; $$
LANGUAGE plpgsql;

-- Down Migration
DROP FUNCTION get_top_highlight_courses;