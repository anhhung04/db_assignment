-- Up Migration
INSERT INTO users (id, username, password, fname, lname, email, address, avatar_url, account_type, status, phone_no, birthday, created_at, updated_at)
VALUES ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f','user1','$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm','Quỳnh','Nguyễn Thị Như', 'nttq@gmail.com', 'KTX Hòa Hảo, Quận 10, Tp.HCM', NULL, 'teacher', 'active', '0837317823', '2024-04-15', '2024-04-15 00:22:30.000000', '2024-04-15 00:22:32.000000');
INSERT INTO permissions(user_id, read, "create", update, delete, resource_id, created_at, updated_at)
VALUES ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', true, false, true, false, '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', '2024-04-15 00:22:30.000000', '2024-04-15 00:22:32.000000');
-- Down Migration
DELETE FROM users WHERE id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f';
DELETE FROM permissions WHERE user_id = '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f';