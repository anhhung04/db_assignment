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
        status,
        phone_no,
        birthday
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f',
        'user1',
        '$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm',
        'Quỳnh',
        'Nguyễn Thị Như',
        'nttq@gmail.com',
        'KTX Hòa Hảo, Quận 10, Tp.HCM',
        NULL,
        'teacher',
        'active',
        '0837317823',
        '2024-04-15'
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
        status,
        phone_no,
        birthday
    )
VALUES (
        '36a14986-5819-43ac-90af-b75eeb8dce27',
        'user2',
        '$2a$10$oBeKExPjakvzWN0qJ.Q10.zctuE86a.cMewA..zJr8.DC3E6rj9mm',
        'A',
        'Nguyễn Văn',
        'nguyenvana@gmail.com',
        'KTX Hòa Hảo, Quận 10, Tp.HCM',
        NULL,
        'student',
        'active',
        '0123456789',
        '2004-01-01'
    );
-- Down Migration