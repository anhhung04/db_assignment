-- -- Up Migration
-- -- 1.1.1.  Test RAISE EXCEPTIONS Triggers
-- -- enforce_price_constraint_students_join_courses
-- INSERT INTO students_join_courses (student_id, course_id, current_price, created_at, updated_at)
-- VALUES ('550e8400-e29b-41d4-a716-446655440017', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005', 9999, NOW(), NOW());

-- -- check_balance_before_register
-- INSERT INTO users (username, password, fname, lname, email, address, id, avatar_url, account_type, phone_no, birthday, created_at, updated_at, account_balance, display_name) VALUES ('user5', '$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm', 'Quỳnh', 'Nguyễn Như', 'ntq@gmail.com', 'KTX Hòa Hảo, Quận 10, Tp.HCM', '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a92', 'https://www.w3schools.com/w3images/avatar2.png', 'student', '0837317823', '2024-04-15', '2024-05-05 12:17:11.593112', '2024-05-05 12:17:11.593112', 0, 'Nguyễn Thị Như Quỳnh');
-- INSERT INTO students (user_id, english_level, study_history, target) VALUES ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a92', 'A1', 'Không có', 'Học tốt');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a92', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005');

-- --grant_permissions_after_register
-- INSERT INTO users (username, password, fname, lname, email, address, id, avatar_url, account_type, phone_no, birthday, created_at, updated_at, account_balance, display_name) VALUES ('user281', '$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm', 'Quỳnh', 'Nguyễn Như', 'ewk@gmail.com', 'KTX Hòa Hảo, Quận 10, Tp.HCM', '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', 'https://www.w3schools.com/w3images/avatar2.png', 'student', '0837317823', '2024-04-15', '2024-05-05 12:17:11.593112', '2024-05-05 12:17:11.593112', 9999, 'Nguyễn Thị Như Quỳnh');
-- INSERT INTO students (user_id, english_level, study_history, target) VALUES ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', 'A1', 'Không có', 'Học tốt');

-- -- Register for a course
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0007');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0011');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0013');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0014');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0015');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0002');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0020');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0030');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0040');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0050');
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0060');

-- -- Check permissions before register
-- SELECT * FROM permissions WHERE user_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75';
-- --Insert
-- CALL join_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0003');
-- -- Check permissions after register
-- SELECT * FROM permissions WHERE user_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75';
-- -- Unregister from the course
-- DELETE FROM students_join_courses WHERE student_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75' AND course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0002';
-- -- Check permissions after unregister
-- SELECT * FROM permissions WHERE user_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a75';

-- -- 1.2.2. Test Calculate Triggers
-- Testing the rate_course procedure and insert_review_trigger
-- CALL rate_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e0010', '550e8400-e29b-41d4-a716-446655440008', 'This is a comment', 3.2);
-- CALL rate_course('90f5c3b5-6b82-4b6d-85b5-9c1d414e0010', '550e8400-e29b-41d4-a716-446655440015', 'This is another comment', 4.5);

-- -- Testing the update_course_rating_trigger
-- -- After inserting a review, check the rating of the course in the courses table
-- SELECT rating FROM courses WHERE course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010';

-- -- Testing the update_review_trigger and update_course_rating_after_review_update_trigger
-- UPDATE reviews SET rating = 5 WHERE course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010' AND student_id = '550e8400-e29b-41d4-a716-446655440008';

-- -- Testing the count_students_in_course trigger
-- CALL join_course('550e8400-e29b-41d4-a716-446655440015', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0004');
-- DELETE FROM students_join_courses WHERE student_id = '550e8400-e29b-41d4-a716-446655440015' AND course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0004';

-- -- Testing the recalculate_rating trigger
-- INSERT INTO reviews (comment, rating, course_id, student_id) VALUES ('This is another comment', 5, '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010', '550e8400-e29b-41d4-a716-446655440008');
-- UPDATE reviews SET rating = 4 WHERE course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010' AND student_id = '550e8400-e29b-41d4-a716-446655440008';
-- DELETE FROM reviews WHERE course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010' AND student_id = '550e8400-e29b-41d4-a716-446655440008';

-- -- Testing the prevent_course_deletion trigger
-- DELETE FROM courses WHERE course_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010';

-- -- Testing the process_course_purchase trigger
-- INSERT INTO students_join_courses (student_id, course_id) VALUES ('550e8400-e29b-41d4-a716-446655440014', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012');

-- -- 1.2.3
-- -- Testing the list_top_courses_revenue function
-- SELECT * FROM list_top_courses_revenue('2024-01-01', '2024-12-31', 10);

-- -- Testing the list_courses_bought function
-- SELECT * FROM list_courses_bought('36a14986-5819-43ac-90af-b75eeb8dce27', '2024-01-01', '2024-12-31');

-- -- Testing the filter_courses function
-- SELECT * FROM filter_courses('', 'Như Quỳnh', 0, 'Cử nhân', 5, 1);

    -- -- Testing the filter_courses_by_reviews function
    -- SELECT * FROM filter_courses_by_reviews(1, 4.5);

-- -- 1.2.4
-- -- Testing the calculate_exam_score function
-- SELECT calculate_exam_score('550e8400-e29b-41d4-a716-446655440012', 'e7c2a0fc-b46f-4d27-a1d8-69ed8e93b9a2');

-- -- Testing the check_course_eligibility function
-- SELECT check_course_eligibility('550e8400-e29b-41d4-a716-446655440017', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006');

-- -- Testing the get_top_highlight_courses function
-- SELECT * FROM get_top_highlight_courses(5, 4.5);

-- -- Testing the calculate_course_price function
-- SELECT calculate_course_price('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005');

-- -- Testing the join_course procedure
-- CALL join_course('550e8400-e29b-41d4-a716-446655440008', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0011');

-- -- Down Migration
