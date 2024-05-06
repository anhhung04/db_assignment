-- Up Migration
CREATE OR REPLACE FUNCTION list_top_courses_revenue(
    start_date DATE,
    end_date DATE,
    limit_count INT
)
RETURNS TABLE (
    course_id UUID,
    title VARCHAR(100),
    total_revenue DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.course_id, 
        c.title, 
        SUM(sjc.current_price) AS total_revenue
    FROM 
        students_join_courses sjc
    JOIN 
        courses c ON sjc.course_id = c.course_id
    WHERE 
        sjc.created_at BETWEEN start_date AND end_date
    GROUP BY 
        c.course_id
    ORDER BY 
        total_revenue DESC
    LIMIT 
        limit_count;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION list_courses_bought(in_student_id UUID, start_date DATE, end_date DATE)
RETURNS TABLE (
    course_title VARCHAR(100),
    time_bought TIMESTAMP,
    current_price DOUBLE PRECISION,
    teacher_name VARCHAR(200),
    avg_rating DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.title AS course_title,
        sjc.created_at AS time_bought,
        sjc.current_price AS current_price,
        u.display_name AS teacher_name,
        c.rating AS avg_rating
    FROM 
        students_join_courses sjc
    JOIN 
        courses c ON sjc.course_id = c.course_id
    JOIN 
        teachers t ON c.teacher_id = t.user_id
    JOIN 
        users u ON t.user_id = u.id
    WHERE 
        sjc.student_id = in_student_id AND
        sjc.created_at BETWEEN start_date AND end_date
    GROUP BY 
        c.course_id, sjc.created_at, sjc.current_price, u.display_name
    ORDER BY 
        avg_rating DESC;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION filter_courses(p_tag VARCHAR(50), p_teacher_name VARCHAR(100), p_teacher_exp INT, p_teacher_edulevel VARCHAR(100), limit_course INT, paging INT)
RETURNS TABLE(course_id uuid, course_slug VARCHAR(100), thumbnail_url TEXT, title varchar(100), type course_type, description text, rating double precision, level varchar(20), headline varchar(100), content_info varchar(50), amount_price double precision, currency currency_type, total_students integer, teacher_name VARCHAR(100), teacher_id uuid, teacher_avatar TEXT, teacher_edu_level VARCHAR(50)) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.course_id,
        c.course_slug,
        c.thumbnail_url,
        c.title,
        c.type,
        c.description,
        c.rating,
        c.level,
        c.headline,
        c.content_info,
        c.amount_price,
        c.currency,
        c.total_students,
        u.display_name AS teacher_name,
        u.id AS teacher_id,
        u.avatar_url AS teacher_avatar,
        t.educational_level AS teacher_edu_level
    FROM courses c
    INNER JOIN teachers t ON c.teacher_id = t.user_id
    INNER JOIN users u ON t.user_id = u.id
    WHERE LOWER(u.display_name) LIKE '%' || LOWER(p_teacher_name) || '%' AND LOWER(c.content_info) LIKE '%' || LOWER(p_tag) || '%'
    AND EXTRACT(YEAR FROM age(NOW(), t.created_at)) * 12 + EXTRACT(MONTH FROM age(NOW(), t.created_at)) >= p_teacher_exp
    AND LOWER(t.educational_level) LIKE '%' || LOWER(p_teacher_edulevel) || '%'
    ORDER BY c.rating DESC
    LIMIT limit_course OFFSET (paging - 1) * limit_course;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION filter_courses_by_reviews(min_reviews INT, min_rating DOUBLE PRECISION)
RETURNS TABLE (
    course_title VARCHAR(100),
    total_reviews BIGINT,
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
        AVG(r.rating) >= min_rating
    ORDER BY 
        avg_rating DESC, 
        total_reviews DESC;
END; $$
LANGUAGE plpgsql;

-- Down Migration
DROP FUNCTION list_top_courses_revenue;
DROP FUNCTION list_courses_bought;
DROP FUNCTION filter_courses;
DROP FUNCTION filter_courses_by_reviews;