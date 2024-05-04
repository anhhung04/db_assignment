-- Up Migration
CREATE OR REPLACE PROCEDURE public.get_top_highlight_courses (
  min_avg_review DOUBLE PRECISION DEFAULT 0,
  limit_count INTEGER DEFAULT 5
)
AS $$
DECLARE
    course_count INT;
    recent_days INT := 30;
BEGIN
    WHILE course_count < 5 AND recent_days < 90 LOOP
        SELECT COUNT(DISTINCT course_id) INTO course_count
        FROM students_join_courses
        WHERE created_at > NOW() - INTERVAL '1 day' * recent_days;
        recent_days := recent_days + 30;
    END LOOP;

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
END; 
$$ LANGUAGE plpgsql;


-- Down Migration
DROP PROCEDURE get_top_highlight_courses;