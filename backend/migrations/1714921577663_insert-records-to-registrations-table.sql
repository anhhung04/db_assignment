-- Up Migration
INSERT INTO registrations (id, time, content, status) VALUES ('d02d5e7e-38c0-4a71-8f0b-1d6c6a0c4a3e', '2024-05-05 15:03:39.726136', 'Đăng ký khóa học tiếng Anh cơ bản', 'active');
INSERT INTO registrations (id, time, content, status) VALUES ('3f2a6f8a-0b7e-4d1d-b7e7-8d5b0e3b5e3e', '2024-05-05 15:03:39.737804', 'Đăng ký khóa học tiếng Anh giao tiếp', 'inactive');
INSERT INTO registrations (id, time, content, status) VALUES ('a7e5c9e2-2d84-4b8a-9a5d-5cf9df4f1b3d', '2024-05-05 15:03:39.744213', 'Đăng ký khóa học tiếng Anh chuyên ngành', 'active');
INSERT INTO registrations (id, time, content, status) VALUES ('85a3b9f9-2f06-4d9e-8c59-1a18c9a8b4c5', '2024-05-05 15:03:39.750113', 'Đăng ký khóa học tiếng Anh nâng cao', 'inactive');
INSERT INTO registrations (id, time, content, status) VALUES ('f7404df3-7eff-4a1e-a1b9-6e2b9dd33d34', '2024-05-05 15:03:39.756496', 'Đăng ký khóa học tiếng Anh kinh doanh', 'active');
-- Down Migration
DELETE FROM registrations WHERE id IN ('d02d5e7e-38c0-4a71-8f0b-1d6c6a0c4a3e', '3f2a6f8a-0b7e-4d1d-b7e7-8d5b0e3b5e3e', 'a7e5c9e2-2d84-4b8a-9a5d-5cf9df4f1b3d', '85a3b9f9-2f06-4d9e-8c59-1a18c9a8b4c5', 'f7404df3-7eff-4a1e-a1b9-6e2b9dd33d34');