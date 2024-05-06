-- Up Migration
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440001', 'knowing', '8a04a36e-d1f5-4a59-8da6-07f19fc26f3b', 'f70d978e-cd06-4f11-b228-8e4fbf1d7758');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440003', 'would love', 'f3cfa4c5-f63a-429e-894d-1f202f8ef5d3', 'eab4b1cf-0045-46f1-b9fc-43018173dc71');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440000', 'would', '2e9786bb-422b-4911-9da8-8b3a9e9291b4', 'f0a01a6b-65e5-4f36-b531-22c9af4ec307');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440002', 'be', '26cfd138-fa2c-49e6-bfa4-4f6e069c5fbb', 'dd5e120d-08a3-4598-b99d-f457d8d292bc');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440008', 'calculate', '54c50d19-1a0a-4091-91f6-88d53cc3d1aa', '3480ebed-04a1-45ac-9353-4875d1f7ebff');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440006', 'powerful', 'adbaab9c-74db-4c47-ba33-6928a1d1f8f7', 'a1f74c17-5eeb-4aeb-b319-67d4e729b5ed');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440004', 'show', '6c5b1a16-3482-434d-9518-6f0e1c558f9a', '7a299134-4f11-4933-8333-fa91d8dbb228');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440007', 'students', '3d748537-c2d3-40bb-8540-8db90b36528d', '8bfb789a-5eb4-48d1-9827-52e2c394f13e');
INSERT INTO wrong_answers (id, student_answer, taking_exam_id, question_id) VALUES ('550e8400-e29b-41d4-a716-446655440005', 'generate', 'd5a65b11-2fe6-456a-bf26-02884873208e', '8d11cbe5-12ad-4e41-b4c8-b37224f27ef3');

-- Down Migration
DELETE FROM wrong_answers WHERE id IN ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440005');