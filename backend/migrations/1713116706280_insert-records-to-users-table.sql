-- Up Migration
INSERT INTO users (
        id,
        username,
        password,
        fname,
        lname,
        email,
        address,
        avatar_url,
        account_type,
        phone_no,
        birthday
    )
VALUES (
<<<<<<< HEAD
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f',
        'user1',
        '$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm',
        'Quỳnh',
        'Nguyễn Thị Như',
        'nttq@gmail.com',
        'KTX Hòa Hảo, Quận 10, Tp.HCM',
        NULL,
        'teacher',
        '0837317823',
        '2024-04-15'
    );
INSERT INTO teachers (
        user_id,
        educational_level,
        rating
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f',
        'Đại học',
        4.5
    );
INSERT INTO users (
        id,
        username,
        password,
        fname,
        lname,
        email,
        address,
        avatar_url,
        account_type,
        phone_no,
        birthday
    )
VALUES (
=======
>>>>>>> ae8c95ef25ecef4ee08c098055e93948898e68c0
        '36a14986-5819-43ac-90af-b75eeb8dce27',
        'user2',
        '$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm',
        'A',
        'Nguyễn Văn',
        'nguyenvana@gmail.com',
        'KTX Hòa Hảo, Quận 10, Tp.HCM',
        NULL,
        'student',
        '0123456789',
        '2004-01-01'
    );
INSERT INTO students (
        user_id,
        english_level,
        study_history,
        target
    )
VALUES (
        '36a14986-5819-43ac-90af-b75eeb8dce27',
        'A1',
        'Không có',
        'Học tốt'
    );
-- Down Migration
DELETE FROM users WHERE id IN ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', '36a14986-5819-43ac-90af-b75eeb8dce27');