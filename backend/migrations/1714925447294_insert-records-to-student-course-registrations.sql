-- Up Migration
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440014', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008', 'd02d5e7e-38c0-4a71-8f0b-1d6c6a0c4a3e');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440011', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005', 'f7404df3-7eff-4a1e-a1b9-6e2b9dd33d34');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440017', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0002', '3f2a6f8a-0b7e-4d1d-b7e7-8d5b0e3b5e3e');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440007', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006', 'a7e5c9e2-2d84-4b8a-9a5d-5cf9df4f1b3d');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012', '3f2a6f8a-0b7e-4d1d-b7e7-8d5b0e3b5e3e');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440008', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008', 'a7e5c9e2-2d84-4b8a-9a5d-5cf9df4f1b3d');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440015', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0015', '85a3b9f9-2f06-4d9e-8c59-1a18c9a8b4c5');
INSERT INTO student_course_registrations (student_id, course_id, registration_id) VALUES ('550e8400-e29b-41d4-a716-446655440012', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008', 'a7e5c9e2-2d84-4b8a-9a5d-5cf9df4f1b3d');

-- Down Migration
DELETE FROM student_course_registrations WHERE student_id IN ('550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440017', '550e8400-e29b-41d4-a716-446655440007', '36a14986-5819-43ac-90af-b75eeb8dce27', '550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440012');