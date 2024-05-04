-- Up Migration
CREATE OR REPLACE PROCEDURE get_top_highlight_courses (
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


CREATE OR REPLACE PROCEDURE calculate_totals_and_course_sales(
    in_student_id UUID,
    start_date DATE,
    end_date DATE,
    in_course_id UUID
)
AS $$
DECLARE
    total_spent FLOAT;
    course_sales INTEGER;
BEGIN

    SELECT SUM(c.amount_price) INTO total_spent
    FROM students_join_courses s
    JOIN courses c ON s.course_id = c.course_id
    WHERE s.student_id = in_student_id AND s.created_at BETWEEN start_date AND end_date;

    RAISE NOTICE 'Total amount spent by student %: %', in_student_id, total_spent;

    SELECT COUNT(*) INTO course_sales
    FROM students_join_courses
    WHERE course_id = in_course_id AND created_at BETWEEN start_date AND end_date;

    RAISE NOTICE 'Number of sales for course %: %', in_course_id, course_sales;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE list_courses_and_revenue(
    in_student_id UUID,
    start_date DATE,
    end_date DATE
)
AS $$
BEGIN
    SELECT c.course_id, c.title, t.user_id AS teacher_id, SUM(c.amount_price) AS total_revenue
    FROM students_join_courses s
    JOIN courses c ON s.course_id = c.course_id
    JOIN teachers t ON c.teacher_id = t.user_id
    WHERE s.student_id = in_student_id AND s.created_at BETWEEN start_date AND end_date
    GROUP BY c.course_id, t.user_id;
END;
$$ LANGUAGE plpgsql;

-- Down Migration
DROP PROCEDURE get_top_highlight_courses;
DROP PROCEDURE list_courses_and_revenue;
DROP PROCEDURE calculate_totals_and_course_sales;