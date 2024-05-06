-- Up Migration
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('f80e84bf-2bf5-4eb1-bd5e-94d92a3e5f31', 'Tìm hiểu về cấu trúc và sử dụng của động từ phản xạ trong tiếng Anh.', 'Bài Học 1: Động Từ Phản Xạ', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('303187a1-d5e0-4c8c-b7d3-50a134aa6f25', 'Học cách sử dụng tiếng Anh trong môi trường kinh doanh và giao dịch quốc tế.', 'Bài Học 1: Giao Tiếp Kinh Doanh', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('fc07812a-dfd2-40e1-a0cc-8b0487a4b35f', 'Tập trung vào việc cải thiện khả năng nghe tiếng Anh thông qua các bài tập và bài nghe thực tế.', 'Bài Học 1: Nghe Hiểu Cơ Bản', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('9f3c7f1d-bf41-46d0-9a02-6b9a68c25510', 'Học cách giao tiếp tiếng Anh trong các tình huống du lịch và khám phá văn hóa.', 'Bài Học 1: Giao Tiếp Du Lịch', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('75830cbb-f2fd-4f27-b2c3-cf0a564ef207', 'Học cách giao tiếp tiếng Anh trong môi trường thương mại và giao dịch kinh doanh.', 'Bài Học 1: Giao Tiếp Thương Mại', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0013');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('c8b4a05b-01bb-4ac5-9d42-0e5da93b0f14', 'Hướng dẫn cách phát âm tiếng Anh chuẩn và cải thiện khả năng nghe hiểu.', 'Bài Học 1: Phát Âm Chuẩn', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('16f3c5f4-4950-41cf-82e1-c9b6d17ee812', 'Học cách đọc, viết và nói tiếng Anh trong lĩnh vực học thuật và nghiên cứu.', 'Bài Học 1: Tiếng Anh Học Thuật', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006');
INSERT INTO lessons (id, description, title, created_at, updated_at, course_id) VALUES ('db4d7f30-ae3e-4542-8ae4-f55e374f49c8', 'Nâng cao kỹ năng giao tiếp tiếng Anh trong các tình huống phức tạp.', 'Bài Học 1: Giao Tiếp Nâng Cao', '2024-05-06 00:49:04.096657', '2024-05-06 00:49:04.096657', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0007');

-- Down Migration
DELETE FROM lessons WHERE id IN ('f80e84bf-2bf5-4eb1-bd5e-94d92a3e5f31', '303187a1-d5e0-4c8c-b7d3-50a134aa6f25', 'fc07812a-dfd2-40e1-a0cc-8b0487a4b35f', '9f3c7f1d-bf41-46d0-9a02-6b9a68c25510', '75830cbb-f2fd-4f27-b2c3-cf0a564ef207', 'c8b4a05b-01bb-4ac5-9d42-0e5da93b0f14', '16f3c5f4-4950-41cf-82e1-c9b6d17ee812', 'db4d7f30-ae3e-4542-8ae4-f55e374f49c8');