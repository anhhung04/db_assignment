-- Up Migration
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Intermediate', 'Studied English for 2 years in high school.', 'Improve speaking', '550e8400-e29b-41d4-a716-446655440014', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Advanced', 'Took English courses at university for 4 years.', 'Prepare for TOEFL', '550e8400-e29b-41d4-a716-446655440011', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Beginner', 'Limited exposure to English during schooling.', 'Learn basics', '550e8400-e29b-41d4-a716-446655440017', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Intermediate', 'Self-studied English online for 1 year.', 'Enhance skills', '550e8400-e29b-41d4-a716-446655440007', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Advanced', 'Attended an English immersion program for 6 months.', 'Achieve fluency', '36a14986-5819-43ac-90af-b75eeb8dce27', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Intermediate', 'Took English classes at language institute for 3 years.', 'Prepare for IELTS', '550e8400-e29b-41d4-a716-446655440008', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Advanced', 'Lived in an English-speaking country for 5 years.', 'Master language', '550e8400-e29b-41d4-a716-446655440015', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
INSERT INTO students (english_level, study_history, target, user_id, created_at, updated_at) VALUES ('Intermediate', 'Studied English in middle school for 2 years.', 'Improve comprehension', '550e8400-e29b-41d4-a716-446655440012', '2024-05-05 14:49:28.036052', '2024-05-05 14:49:28.036052');
-- Down Migration
DELETE FROM students WHERE user_id IN ('550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440017', '550e8400-e29b-41d4-a716-446655440007', '36a14986-5819-43ac-90af-b75eeb8dce27', '550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440012');