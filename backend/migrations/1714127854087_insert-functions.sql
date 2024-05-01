-- Up Migration
CREATE OR REPLACE FUNCTION get_top_highlight_courses(limit_count INT, min_avg_review DOUBLE PRECISION)
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
BEGIN
    RETURN QUERY
    SELECT
        c.course_id,
        c.title,
        c.rating,
        c.total_students,
        COUNT(DISTINCT sjc.student_id) AS recent_students,
        c.access_count,
        COUNT(r.id) AS total_reviews,
        COALESCE(AVG(r.rating), 0) AS avg_review
    FROM
        courses c
    LEFT JOIN
        reviews r ON c.course_id = r.course_id
    LEFT JOIN
        students_join_courses sjc ON c.course_id = sjc.course_id AND sjc.created_at > NOW() - INTERVAL '1 day' * recent_days
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