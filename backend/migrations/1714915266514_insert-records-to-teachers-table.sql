-- Up Migration
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', 'Cử nhân', 0, '2024-05-05 12:17:11.593112', '2024-05-05 12:17:11.593112');
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440009', 'Thạc sĩ', 0, '2024-05-05 13:02:58.794680', '2024-05-05 13:02:58.794680');
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440010', 'Cử nhân', 0, '2024-05-05 13:02:58.794680', '2024-05-05 13:02:58.794680');
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440005', 'Thạc sĩ', 0, '2024-05-05 13:02:58.794680', '2024-05-05 13:02:58.794680');
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440006', 'Cử nhân', 0, '2024-05-05 13:02:58.794680', '2024-05-05 13:02:58.794680');
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440018', 'Thạc sĩ', 0, '2024-05-05 13:02:58.794680', '2024-05-05 13:02:58.794680');
INSERT INTO teachers (user_id, educational_level, rating, created_at, updated_at) VALUES ('550e8400-e29b-41d4-a716-446655440013', 'Tiến sĩ', 0, '2024-05-05 13:02:58.794680', '2024-05-05 13:02:58.794680');

-- Down Migration
DELETE FROM teachers WHERE user_id IN ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', '550e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440018', '550e8400-e29b-41d4-a716-446655440013');