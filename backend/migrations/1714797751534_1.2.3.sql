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

CREATE OR REPLACE FUNCTION filter_courses(p_teacher_name VARCHAR(100), p_teacher_exp INT, p_teacher_level VARCHAR(100))
RETURNS TABLE(id UUID, title VARCHAR(100), teacher_id UUID, created_at TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.title, c.teacher_id, c.created_at
    FROM courses c
    INNER JOIN teachers t ON c.teacher_id = t.id
    INNER JOIN users u ON t.user_id = u.id
    WHERE u.display_name LIKE '%' || p_teacher_name || '%' AND t.experience = p_teacher_exp AND t.level = p_teacher_level;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION filter_courses(p_teacher_name VARCHAR(100), p_teacher_exp INT, p_teacher_level VARCHAR)
RETURNS TABLE(course_title VARCHAR(100), teacher_name VARCHAR(100), teacher_exp INT) AS $$
BEGIN
    RETURN QUERY
    SELECT c.title, u.display_name, EXTRACT(YEAR FROM age(NOW(), t.created_at)) * 12 + EXTRACT(MONTH FROM age(NOW(), t.created_at))
    FROM courses c
    INNER JOIN teachers t ON c.teacher_id = t.user_id
    INNER JOIN users u ON t.user_id = u.id
    WHERE u.display_name LIKE '%' || p_teacher_name || '%' 
    AND EXTRACT(YEAR FROM age(NOW(), t.created_at)) * 12 + EXTRACT(MONTH FROM age(NOW(), t.created_at)) >= p_teacher_exp 
    AND t.level = p_teacher_level;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION filter_courses_by_reviews(min_reviews INT, min_rating DOUBLE PRECISION)
RETURNS TABLE (
    course_title VARCHAR(100),
    total_reviews INT,
    avg_rating DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.title AS course_title,
        COUNT(r.id) AS total_reviews,
        AVG(r.rating) AS avg_rating
    FROM 
        courses c
    LEFT JOIN 
        reviews r ON c.course_id = r.course_id
    GROUP BY 
        c.course_id
    HAVING 
        COUNT(r.id) >= min_reviews AND 
        AVG(r.rating) >= min_rating;
END; $$
LANGUAGE plpgsql;

-- Down Migration
DROP PROCEDURE list_courses_and_revenue;
DROP PROCEDURE calculate_totals_and_course_sales;
DROP FUNCTION filter_courses;
DROP FUNCTION filter_courses_by_reviews;