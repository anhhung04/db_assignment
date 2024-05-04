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


-- Down Migration
DROP FUNCTION IF EXISTS calculate_exam_score;
DROP FUNCTION IF EXISTS check_course_eligibility;
DROP FUNCTION IF EXISTS get_top_students;