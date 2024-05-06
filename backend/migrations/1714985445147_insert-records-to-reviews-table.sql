-- Up Migration
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (1, 'Great course! Really helped me improve my English skills.', 4.5, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008', '550e8400-e29b-41d4-a716-446655440014');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (2, 'Excellent content, highly recommend it!', 5, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005', '550e8400-e29b-41d4-a716-446655440011');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (3, 'This course was okay, but I expected more.', 3, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012', '550e8400-e29b-41d4-a716-446655440007');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (4, 'The course material was too easy for me.', 2.5, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009', '550e8400-e29b-41d4-a716-446655440017');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (5, 'Outstanding course, helped me a lot in my job.', 5, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0013', '36a14986-5819-43ac-90af-b75eeb8dce27');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (6, 'The instructor was very knowledgeable.', 4, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006', '550e8400-e29b-41d4-a716-446655440015');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (7, 'I struggled with some of the concepts in this course.', 3.5, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0007', '550e8400-e29b-41d4-a716-446655440012');
INSERT INTO reviews (id, comment, rating, created_at, course_id, student_id) VALUES (8, 'The course was too advanced for my level.', 2, '2024-05-05 14:49:28.036052', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010', '550e8400-e29b-41d4-a716-446655440008');

-- Down Migration
DELETE FROM reviews WHERE id IN (1, 2, 3, 4, 5, 6, 7, 8);