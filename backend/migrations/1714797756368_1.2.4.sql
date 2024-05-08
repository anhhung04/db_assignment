-- Up Migration
CREATE OR REPLACE FUNCTION calculate_exam_score(in_student_id uuid, in_exam_id uuid) RETURNS DOUBLE PRECISION AS $$
DECLARE
    question_score DOUBLE PRECISION;
    exam_score DOUBLE PRECISION := 0;
    question RECORD;
    in_taking_exam_id uuid;
    wrong_answer_exists BOOLEAN;
BEGIN
    SELECT id INTO in_taking_exam_id FROM taking_exam WHERE student_id = in_student_id AND exam_id = in_exam_id;

    FOR question IN SELECT * FROM questions WHERE id IN (
        SELECT questions.id FROM questions
        JOIN subsections ON questions.subsection_id = subsections.id
        JOIN sections ON subsections.section_id = sections.id
        WHERE sections.exam_id = in_exam_id
    ) LOOP
        SELECT EXISTS (
            SELECT 1
            FROM wrong_answers
            WHERE question_id = question.id AND taking_exam_id = in_taking_exam_id
        ) INTO wrong_answer_exists;

        IF NOT wrong_answer_exists THEN
            exam_score := exam_score + question.score;
        END IF;
    END LOOP;
    UPDATE taking_exam
    SET score = exam_score, updated_at = now()
    WHERE id = in_taking_exam_id;

    RETURN exam_score;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_course_eligibility(student_id uuid, in_course_id uuid) RETURNS BOOLEAN AS $$
DECLARE
    in_account_balance DOUBLE PRECISION;
    course_price DOUBLE PRECISION;
    money_type currency_type;
BEGIN
    SELECT account_balance INTO in_account_balance FROM users WHERE id = student_id;
    SELECT amount_price INTO course_price FROM courses WHERE course_id = in_course_id;
    SELECT currency INTO money_type FROM courses WHERE course_id = in_course_id;
    course_price := change_currency(course_price, money_type);
    IF in_account_balance >= course_price THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION get_top_students(course_id uuid) RETURNS TABLE(student_id uuid, score double precision) AS $$
-- DECLARE
--     exam RECORD;
--     student_score DOUBLE PRECISION;
-- BEGIN
--     FOR exam IN SELECT * FROM exams LOOP
--         student_score := calculate_exam_score(student_id, exam.id);
--         RETURN QUERY SELECT student_id, student_score;
--     END LOOP;
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_top_highlight_courses(limit_count INTEGER DEFAULT 5, min_avg_review DOUBLE PRECISION DEFAULT 0)
RETURNS TABLE(course_id uuid, course_slug VARCHAR(100), thumbnail_url TEXT, title varchar(100), type course_type, description TEXT, rating double precision, level varchar(20), headline varchar(100), content_info varchar(50), amount_price double precision, currency currency_type, total_students integer, recent_students integer, total_reviews integer, teacher_name VARCHAR(100), teacher_id uuid, teacher_avatar TEXT) AS $$
DECLARE
    course_count INT;
    recent_months INT := 1;
BEGIN
    WHILE course_count < limit_count AND recent_months < 4 LOOP
        SELECT COUNT(DISTINCT sjc.course_id) INTO course_count
        FROM students_join_courses sjc
        WHERE sjc.created_at > NOW() - INTERVAL '1 month' * recent_months;
        recent_months := recent_months + 1;
    END LOOP;

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
        (SELECT COUNT(DISTINCT sjc.student_id)::integer FROM students_join_courses sjc WHERE sjc.course_id = c.course_id AND sjc.created_at > NOW() - INTERVAL '1 month') AS recent_students,
        COUNT(r.id)::integer AS total_reviews,
        u.display_name AS teacher_name,
        u.id AS teacher_id,
        u.avatar_url AS teacher_avatar
    FROM
        courses c
    LEFT JOIN
        reviews r ON c.course_id = r.course_id
    LEFT JOIN
        students_join_courses sjc ON c.course_id = sjc.course_id AND sjc.created_at > NOW() - INTERVAL '1 month' * recent_months
    LEFT JOIN
        users u ON c.teacher_id = u.id
    GROUP BY
        c.course_id, c.course_slug, c.thumbnail_url, c.title, c.type, c.description, c.rating, c.level, c.headline, c.content_info, c.amount_price, c.currency, c.total_students, u.display_name, u.id, u.avatar_url
    HAVING
        COALESCE(AVG(r.rating), 0) >= min_avg_review
    ORDER BY
        recent_students DESC,
        c.total_students DESC,
        c.rating DESC,
        total_reviews DESC
    LIMIT
        limit_count;
END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_course_price(
    in_student_id UUID,
    in_course_id UUID
)
RETURNS DOUBLE PRECISION AS $$
DECLARE
    bought_course RECORD;
    course RECORD;
    course_price DOUBLE PRECISION;
    max_points DOUBLE PRECISION := 0.2; 
    solve_threshold DOUBLE PRECISION := 0;
    x DOUBLE PRECISION := 0;
    discount_amount DOUBLE PRECISION;
BEGIN
    FOR course IN (SELECT * FROM courses)
    LOOP
        solve_threshold := solve_threshold + change_currency(course.amount_price, course.currency);
    END LOOP;

    FOR bought_course IN (SELECT course_id, current_price FROM students_join_courses WHERE student_id = in_student_id)
    LOOP
        IF EXISTS (SELECT 1 FROM reviews WHERE course_id = bought_course.course_id AND student_id = in_student_id) THEN
            x := x + bought_course.current_price;
        ELSE
            x := x + bought_course.current_price * 0.5;
        END IF;
    END LOOP;

    discount_amount := max_points / (solve_threshold^2) * (x^2);
    SELECT change_currency(amount_price, currency) INTO course_price
    FROM courses
    WHERE course_id = in_course_id;
    course_price := FLOOR(course_price * (1 - discount_amount) * 100) / 100;

    RETURN course_price;
END;
$$ LANGUAGE plpgsql;



-- Down Migration
DROP FUNCTION IF EXISTS calculate_exam_score;
DROP FUNCTION IF EXISTS check_course_eligibility;
-- DROP FUNCTION IF EXISTS get_top_students;
DROP FUNCTION IF EXISTS get_top_highlight_courses;
DROP FUNCTION IF EXISTS calculate_course_price;

