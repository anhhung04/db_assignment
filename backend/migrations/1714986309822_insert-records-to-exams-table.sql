-- Up Migration
INSERT INTO exams (exam_id, duration, title, created_at, updated_at) VALUES ('5df41881-50a8-4e0f-8155-af5a3d8dc6b3', '0 years 0 mons 0 days 2 hours 30 mins 0.0 secs', 'Midterm Exam', '2024-05-05 17:20:29.927721', '2024-05-05 17:20:29.927721');
INSERT INTO exams (exam_id, duration, title, created_at, updated_at) VALUES ('e7c2a0fc-b46f-4d27-a1d8-69ed8e93b9a2', '0 years 0 mons 0 days 1 hours 45 mins 0.0 secs', 'Final Exam', '2024-05-05 17:20:29.937295', '2024-05-05 17:20:29.937295');
INSERT INTO exams (exam_id, duration, title, created_at, updated_at) VALUES ('6c84fb90-12c4-11e1-840d-7b25c5ee775a', '0 years 0 mons 0 days 1 hours 0 mins 0.0 secs', 'Quiz', '2024-05-05 17:20:29.945320', '2024-05-05 17:20:29.945320');
INSERT INTO exams (exam_id, duration, title, created_at, updated_at) VALUES ('9452bb2e-0b73-4704-b7f4-7286d6f7d9a0', '0 years 0 mons 0 days 1 hours 15 mins 0.0 secs', 'Test', '2024-05-05 17:20:29.954730', '2024-05-05 17:20:29.954730');
INSERT INTO exams (exam_id, duration, title, created_at, updated_at) VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '0 years 0 mons 0 days 2 hours 0 mins 0.0 secs', 'Final Project Presentation', '2024-05-05 17:20:29.970042', '2024-05-05 17:20:29.970042');

-- Down Migration
DELETE FROM exams WHERE exam_id IN ('5df41881-50a8-4e0f-8155-af5a3d8dc6b3', 'e7c2a0fc-b46f-4d27-a1d8-69ed8e93b9a2', '6c84fb90-12c4-11e1-840d-7b25c5ee775a', '9452bb2e-0b73-4704-b7f4-7286d6f7d9a0', 'f47ac10b-58cc-4372-a567-0e02b2c3d479');