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

<<<<<<< HEAD

=======
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
    course_price := course_price * (1 - discount_amount);

    RETURN course_price;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE join_course(
    in_student_id UUID,
    in_course_id UUID
)
AS $$
DECLARE
    in_current_price DOUBLE PRECISION;
    student_balance DOUBLE PRECISION;
    course_type course_type;
BEGIN
    IF EXISTS (SELECT 1 FROM students_join_courses WHERE student_id = in_student_id AND course_id = in_course_id) THEN
        RAISE EXCEPTION 'The student has already registered for this course';
    END IF;

    in_current_price := calculate_course_price(in_student_id, in_course_id);
    SELECT account_balance INTO student_balance FROM users WHERE id = in_student_id;
    SELECT type INTO course_type FROM courses WHERE course_id = in_course_id;
    IF course_type = 'paid' THEN
        IF student_balance < in_current_price THEN
            RAISE EXCEPTION 'The student does not have enough money to join the course';
        END IF;
        UPDATE users SET account_balance = account_balance - in_current_price WHERE id = in_student_id;
    END IF;
    
    INSERT INTO students_join_courses (student_id, course_id, current_price)
    VALUES (in_student_id, in_course_id, in_current_price);
END;
$$ LANGUAGE plpgsql;
>>>>>>> ae8c95ef25ecef4ee08c098055e93948898e68c0


-- Down Migration
DROP FUNCTION IF EXISTS calculate_exam_score;
DROP FUNCTION IF EXISTS check_course_eligibility;
DROP FUNCTION IF EXISTS get_top_students;
<<<<<<< HEAD
DROP FUNCTION IF EXISTS get_top_highlight_courses;
=======
DROP FUNCTION IF EXISTS get_top_highlight_courses;
DROP FUNCTION IF EXISTS calculate_course_price;
DROP PROCEDURE IF EXISTS join;
>>>>>>> ae8c95ef25ecef4ee08c098055e93948898e68c0
