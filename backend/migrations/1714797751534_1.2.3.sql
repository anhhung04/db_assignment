-- Up Migration
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
DROP PROCEDURE list_courses_and_revenue;
DROP PROCEDURE calculate_totals_and_course_sales;
