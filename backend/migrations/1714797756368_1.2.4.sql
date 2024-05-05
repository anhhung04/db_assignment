-- Up Migration
CREATE OR REPLACE FUNCTION calculate_exam_score(student_id uuid, exam_id uuid) RETURNS DOUBLE PRECISION AS $$
DECLARE
    question_score DOUBLE PRECISION;
    exam_score DOUBLE PRECISION := 0;
    question RECORD;
BEGIN
    FOR question IN SELECT * FROM questions WHERE id IN (
        SELECT questions.id FROM questions
        JOIN subsections ON questions.subsection_id = subsections.id
        JOIN sections ON subsections.section_id = sections.id
        WHERE sections.exam_id = exam_id
    ) LOOP
        SELECT questions.score INTO question_score
        FROM questions
        LEFT JOIN wrong_answers ON questions.id = wrong_answers.answer_id
        WHERE questions.id = question.id AND wrong_answers.answer_id IS NULL;

        IF question_score IS NOT NULL THEN
            exam_score := exam_score + question_score;
        END IF;
    END LOOP;

    RETURN exam_score;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_course_eligibility(student_id uuid, course_id uuid) RETURNS BOOLEAN AS $$
DECLARE
    account_balance DOUBLE PRECISION;
    course_price DOUBLE PRECISION;
BEGIN
    SELECT account_balance INTO account_balance FROM users WHERE id = student_id;
    SELECT amount_price INTO course_price FROM courses WHERE course_id = course_id;

    IF account_balance >= course_price THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_top_students(course_id uuid) RETURNS TABLE(student_id uuid, score double precision) AS $$
DECLARE
    exam RECORD;
    student_score DOUBLE PRECISION;
BEGIN
    FOR exam IN SELECT * FROM exams LOOP
        IF exam.id IN (
            SELECT exam_id FROM sections
            JOIN subsections ON sections.id = subsections.section_id
            JOIN questions ON subsections.id = questions.subsection_id
            JOIN lessons ON questions.lesson_id = lessons.id
            WHERE lessons.course_id = course_id
        ) THEN
            SELECT student_id, score INTO student_score
            FROM taking_exam
            WHERE exam_id = exam.id
            ORDER BY score DESC
            LIMIT 5;

            student_id := student_score.student_id;
            score := student_score.score;
            RETURN NEXT;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_top_highlight_courses(limit_count INTEGER DEFAULT 5, min_avg_review DOUBLE PRECISION DEFAULT 0)
RETURNS TABLE(course_id uuid, title varchar(100), type course_type, description varchar(200), rating double precision, level varchar(20), headline varchar(100), content_info varchar(50), amount_price double precision, currency currency_type, total_students integer, recent_students integer, total_reviews integer, avg_review double precision) AS $$
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
        COALESCE(AVG(r.rating), 0) AS avg_review
    FROM
        courses c
    LEFT JOIN
        reviews r ON c.course_id = r.course_id
    LEFT JOIN
        students_join_courses sjc ON c.course_id = sjc.course_id AND sjc.created_at > NOW() - INTERVAL '1 month' * recent_months
    GROUP BY
        c.course_id, c.title, c.type, c.description, c.rating, c.level, c.headline, c.content_info, c.amount_price, c.currency, c.total_students
    HAVING
        COALESCE(AVG(r.rating), 0) >= min_avg_review
    ORDER BY
        recent_students DESC,
        c.total_students DESC,
        c.rating DESC,
        total_reviews DESC,
        avg_review DESC
    LIMIT
        limit_count;
END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_course_price(
    in_student_id UUID,
    in_course_id UUID
)
RETURNS FLOAT AS $$
DECLARE
    amount_price FLOAT;
    max_points FLOAT := 0.05; 
    min_points FLOAT := 0.50;
    solve_threshold FLOAT := 0.90;
    x FLOAT;
    total_courses_amount FLOAT;
    student_courses_amount FLOAT;
    discount_amount FLOAT;
BEGIN
    SELECT SUM(amount_price) INTO total_courses_amount FROM courses;

    SELECT SUM(c.amount_price) INTO student_courses_amount
    FROM students_join_courses s
    JOIN courses c ON s.course_id = c.course_id
    WHERE s.student_id = in_student_id;

    x := student_courses_amount / total_courses_amount;

    discount_amount := (min_points - max_points) / (solve_threshold^2) * (x^2) + max_points;

    SELECT amount_price INTO amount_price FROM courses WHERE course_id = in_course_id;
    amount_price := change_currency(amount_price, 'usd');

    amount_price := amount_price * (1 - discount_amount);

    RETURN amount_price;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE join(
    in_student_id UUID,
    in_course_id UUID
)
AS $$
DECLARE
    in_current_price DOUBLE PRECISION;
BEGIN
    SELECT amount_price INTO in_current_price FROM courses WHERE course_id = in_course_id;
    in_current_price := calculate_course_price(in_student_id, in_course_id);
    INSERT INTO students_join_courses (student_id, course_id, current_price)
    VALUES (in_student_id, in_course_id, in_current_price);
END;
$$ LANGUAGE plpgsql;

-- Down Migration
DROP FUNCTION IF EXISTS calculate_exam_score;
DROP FUNCTION IF EXISTS check_course_eligibility;
DROP FUNCTION IF EXISTS get_top_students;
DROP FUNCTION IF EXISTS get_top_highlight_courses;
DROP FUNCTION IF EXISTS calculate_course_price;
DROP PROCEDURE IF EXISTS join;
