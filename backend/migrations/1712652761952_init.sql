-- Up Migration
CREATE TYPE account_type AS ENUM ('operator', 'teacher', 'student');

CREATE TYPE status AS ENUM ('active', 'inactive');

CREATE TABLE users
(
    username     TEXT         NOT NULL,
    password     VARCHAR(100) NOT NULL,
    fname        VARCHAR(100) NOT NULL,
    lname        VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    address      TEXT         NOT NULL,
    id           UUID         NOT NULL
        CONSTRAINT id
            PRIMARY KEY,
    avatar_url   TEXT,
    account_type account_type NOT NULL,
    status       status       NOT NULL,
    manager_id   UUID,
    phone_no     VARCHAR(11),
    birthday     DATE,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO users (username, password, fname, lname, email, address, id, avatar_url, account_type, status, manager_id, phone_no, birthday, created_at, updated_at)
VALUES
    ('john_doe', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'John', 'Doe', 'john.doe@example.com', '123 Main St, Anytown, USA', '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', NULL, 'operator', 'active', NULL, '1234567890', '1990-05-15', NOW(), NOW()),
    ('jane_smith', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Jane', 'Smith', 'jane.smith@example.com', '456 Oak St, Othertown, USA', '9a925fc9-6527-4ad3-9493-026b381db209', NULL, 'teacher', 'active', NULL, '0987654321', '1985-10-20', NOW(), NOW()),
    ('alice_green', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Alice', 'Green', 'alice.green@example.com', '789 Elm St, Anycity, USA', '26cfe037-5d95-4748-8432-1a50115db0ab', NULL, 'student', 'active', NULL, '5551234567', '2000-03-10', NOW(), NOW()),
    ('sam_rodriguez', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Sam', 'Rodriguez', 'sam.rodriguez@example.com', '321 Pine St, Anothercity, USA', 'd0d8c7e4-99ef-4a4c-a221-f43f4a2b5364', NULL, 'student', 'active', NULL, '7779876543', '1998-12-01', NOW(), NOW()),
    ('admin1', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Admin', 'One', 'admin1@example.com', '555 Admin Blvd, Admincity, USA', 'b5a76c6b-7323-4b6f-a7c0-f52ae1b23430', NULL, 'operator', 'active', NULL, '9991112222', '1975-08-25', NOW(), NOW()),
    ('manager1', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Manager', 'One', 'manager1@example.com', '123 Manager St, Managertown, USA', 'ff3c59be-5397-497a-8dd1-16e0f4a5c712', NULL, 'operator', 'active', NULL, '3334445555', '1988-07-12', NOW(), NOW()),
    ('manager2', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Manager', 'Two', 'manager2@example.com', '456 Manager St, Managertown, USA', '2a79305a-57e7-4e12-bd7a-13558ccdd8ae', NULL, 'operator', 'active', NULL, '6667778888', '1970-02-28', NOW(), NOW()),
    ('student1', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Student', 'One', 'student1@example.com', '123 Student St, Studentville, USA', 'a0452d13-d78c-46de-833d-dbf88b86b03e', NULL, 'student', 'active', NULL, '1231231234', '2005-09-03', NOW(), NOW()),
    ('student2', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Student', 'Two', 'student2@example.com', '456 Student St, Studentville, USA', 'fc785793-fdbb-4eac-aa6f-28f8dab035f4', NULL, 'student', 'active', NULL, '4564564567', '2007-11-15', NOW(), NOW()),
    ('teacher1', '$2a$10$7vXQEsWiQ9o.7GmcRBR4d.Gf5Y8d/5bAme2kTP4v3kxuSGx22t5va', 'Teacher', 'One', 'teacher1@example.com', '123 Teacher St, Teachertown, USA', 'c92319d9-69d6-48a9-bd46-ee3e41585ef7', NULL, 'teacher', 'active', NULL, '7897897890', '1980-04-18', NOW(), NOW());


CREATE TABLE students
(
    english_level VARCHAR(50),
    study_history VARCHAR(150),
    target        VARCHAR(30),
    student_id    UUID NOT NULL
        CONSTRAINT student_id
            PRIMARY KEY,
    user_id       UUID
        CONSTRAINT user_id
            REFERENCES users,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO students (english_level, study_history, target, student_id, user_id, created_at, updated_at)
VALUES
    ('Intermediate', 'Studied English for 2 years in high school', 'TOEFL', 'e10b92b0-701b-4b2d-a58d-c0787be4c650', 'c92319d9-69d6-48a9-bd46-ee3e41585ef7', NOW(), NOW()),
    ('Beginner', 'No formal study history', 'Basic Communication', 'b6f3c79e-8147-49d8-bb43-9d8cf6a15b23', 'fc785793-fdbb-4eac-aa6f-28f8dab035f4', NOW(), NOW()),
    ('Advanced', 'Studied English literature in university', 'IELTS', '91b36a3d-b310-4df3-bc1e-7f60a0863b3b', 'a0452d13-d78c-46de-833d-dbf88b86b03e', NOW(), NOW()),
    ('Intermediate', 'Attended English language courses for 1 year', 'TOEIC', 'fbfb3d9a-99b5-4b5b-b0ac-c7af9f568e65', '2a79305a-57e7-4e12-bd7a-13558ccdd8ae', NOW(), NOW()),
    ('Advanced', 'Participated in English-speaking exchange programs', 'IELTS', 'e70c68b2-af99-4ec5-b1b0-20a230422b17', 'ff3c59be-5397-497a-8dd1-16e0f4a5c712', NOW(), NOW()),
    ('Intermediate', 'Studied English for 3 years in middle school', 'TOEFL', '8e99e3d1-9c1a-4d7f-bb63-24bc63b77b97', 'b5a76c6b-7323-4b6f-a7c0-f52ae1b23430', NOW(), NOW()),
    ('Beginner', 'No formal study history', 'Basic Communication', '3af0da62-2f60-4682-ba84-92b857fbd21c', 'd0d8c7e4-99ef-4a4c-a221-f43f4a2b5364', NOW(), NOW()),
    ('Advanced', 'Lived in an English-speaking country for 5 years', 'TOEFL', 'bb2e6a11-8eb8-44d4-8166-b96a9f4e9368', '26cfe037-5d95-4748-8432-1a50115db0ab', NOW(), NOW()),
    ('Intermediate', 'Studied English for 2 years in high school', 'TOEIC', '8f374d5b-57f0-468a-935b-2b4d9873fcb2', '9a925fc9-6527-4ad3-9493-026b381db209', NOW(), NOW()),
    ('Advanced', 'Participated in English-speaking exchange programs', 'IELTS', '9d3a5292-b9c3-40a8-93df-ec8d1e8d8626', '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', NOW(), NOW());


CREATE TABLE activities
(
    activity_id UUID NOT NULL
        CONSTRAINT activity_id
            PRIMARY KEY,
    occur_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by  VARCHAR(50),
    action      VARCHAR(50),
    dest        VARCHAR(50),
    note        VARCHAR(100),
    user_id     UUID
        CONSTRAINT user_id
            REFERENCES users,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO activities (activity_id, occur_at, created_by, action, dest, note, user_id, created_at, updated_at)
VALUES
    ('a8292a9a-cb02-4d7b-b1b8-4864b10e6154', NOW(), 'Admin', 'Login', 'Dashboard', 'User logged in successfully', '26cfe037-5d95-4748-8432-1a50115db0ab', NOW(), NOW()),
    ('98e6b63a-3611-4978-a7f7-0c2a1240c3de', NOW(), 'Manager', 'Create', 'Course', 'New course created', '2a79305a-57e7-4e12-bd7a-13558ccdd8ae', NOW(), NOW()),
    ('4c1456c9-9369-4560-aa47-19655b4970d9', NOW(), 'Admin', 'Delete', 'User', 'User account deleted', '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', NOW(), NOW()),
    ('623b8fe8-382b-4968-99a6-3c65c7f51a93', NOW(), 'Teacher', 'Update', 'Assignment', 'Assignment details updated', '9a925fc9-6527-4ad3-9493-026b381db209', NOW(), NOW()),
    ('b66d1f7e-0728-4c53-9d7b-4513b0de1534', NOW(), 'Admin', 'Create', 'User', 'New user created', 'a0452d13-d78c-46de-833d-dbf88b86b03e', NOW(), NOW()),
    ('fd8b6329-5ccf-4574-843f-25d49c094350', NOW(), 'Manager', 'Update', 'Course', 'Course details updated', 'b5a76c6b-7323-4b6f-a7c0-f52ae1b23430', NOW(), NOW()),
    ('dc415794-b33f-4567-b1c8-bb2cfde590d0', NOW(), 'Teacher', 'Delete', 'Assignment', 'Assignment deleted', 'c92319d9-69d6-48a9-bd46-ee3e41585ef7', NOW(), NOW()),
    ('7c6af30b-3aef-45a7-a4e7-2d3b17603602', NOW(), 'Student', 'Submit', 'Assignment', 'Assignment submitted', 'd0d8c7e4-99ef-4a4c-a221-f43f4a2b5364', NOW(), NOW()),
    ('e2992a9d-19e5-496d-a95d-b94db19c2d1e', NOW(), 'Student', 'Complete', 'Quiz', 'Quiz completed', 'fc785793-fdbb-4eac-aa6f-28f8dab035f4', NOW(), NOW()),
    ('cdfdde8d-cb1f-413d-8269-5b531d269cf0', NOW(), 'Manager', 'Delete', 'Course', 'Course deleted', 'ff3c59be-5397-497a-8dd1-16e0f4a5c712', NOW(), NOW());

CREATE TABLE exams
(
    exam_id    UUID    NOT NULL
        CONSTRAINT exam_id
            PRIMARY KEY,
    questions  TEXT    NOT NULL,
    answers    TEXT    NOT NULL,
    duration   INTEGER NOT NULL,
    library_id UUID    NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    "publish " DATE    NOT NULL,
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO exams (exam_id, questions, answers, duration, library_id, "publish ", created_at, updated_at)
VALUES
    ('91740c39-f802-4854-93c0-8b9a4c6a91a2', 'What is the capital of France?', 'Paris', 60, '6f3306af-2f8a-44fb-ae81-8bc8a0dab0e1', '2024-05-01', NOW(), NOW()),
    ('61118bcf-22b7-49a2-8595-ec5fe57b36a0', 'What is the largest planet in the solar system?', 'Jupiter', 90, 'ec27690e-d1aa-485d-aa45-3e1c84eb2617', '2024-05-05', NOW(), NOW()),
    ('d0c65c0e-6710-4c51-8161-5a7606c9d66f', 'Who painted the Mona Lisa?', 'Leonardo da Vinci', 120, 'ad96ae03-d48e-4d20-a320-68645c3a3078', '2024-05-10', NOW(), NOW()),
    ('0d51ac02-3b30-4c09-8a77-1b8d680c45c3', 'What is the chemical symbol for water?', 'H2O', 45, 'cdb3b059-22c3-4693-b1a4-738c53d0a182', '2024-05-15', NOW(), NOW()),
    ('17b7b20f-3d19-4aaf-b51f-d8a62d8e15d5', 'Who wrote "To Kill a Mockingbird"?', 'Harper Lee', 75, 'c7a12ebd-5252-4e49-bac5-9a5a15b73dd5', '2024-05-20', NOW(), NOW()),
    ('e209f0c9-795e-47c0-b20a-ec8257672c91', 'What year did the Titanic sink?', '1912', 60, '5248f623-faaa-4fc2-9e8f-0723d69be1d5', '2024-05-25', NOW(), NOW()),
    ('0f21f2ed-3fc8-42a8-9069-19d66b2a6670', 'Who is credited with inventing the telephone?', 'Alexander Graham Bell', 90, 'd82f0257-9b05-4e36-9867-bfbd6cd1298e', '2024-05-30', NOW(), NOW()),
    ('bf7c7f3e-ecaa-4e1c-b568-1ad2ff4e14e4', 'What is the tallest mountain in the world?', 'Mount Everest', 120, 'cc90e72b-6540-468b-8fa7-d1f8e5f76a84', '2024-06-01', NOW(), NOW()),
    ('f4f12a20-c318-4841-a1ee-8f38eaa52e3a', 'Who was the first person to step on the moon?', 'Neil Armstrong', 180, '83a82e58-8cd2-497e-b62c-d9a0b96ed36b', '2024-06-05', NOW(), NOW()),
    ('75922d7a-24c0-4bb4-b2c4-185a01616eb5', 'What is the boiling point of water in Celsius?', '100', 45, '49796fcf-d7a7-469b-a636-153b2bf7fe07', '2024-06-10', NOW(), NOW());

CREATE TABLE teachers
(
    teacher_id        UUID NOT NULL
        CONSTRAINT teacher_id
            PRIMARY KEY,
    user_id           UUID NOT NULL
        CONSTRAINT user_id
            REFERENCES users,
    educational_level TEXT,
    rating            DOUBLE PRECISION,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO teachers (teacher_id, user_id, educational_level, rating, created_at, updated_at)
VALUES
    ('a2f2e7a5-64a9-4e53-b27d-2e4df50d9577', '9a925fc9-6527-4ad3-9493-026b381db209', 'Master of Science in Mathematics', 4.5, NOW(), NOW()),
    ('c64ac722-f0f4-4b9d-a51e-d14c13dc3453', 'c92319d9-69d6-48a9-bd46-ee3e41585ef7', 'Bachelor of Arts in English Literature', 4.2, NOW(), NOW()),
    ('6a5b59c4-9fb8-48cb-8497-c0a996238568', '2a79305a-57e7-4e12-bd7a-13558ccdd8ae', 'Master of Education in Teaching Science', 4.7, NOW(), NOW()),
    ('d3e12d2b-23fd-4ae3-b3f0-b05f3dc14731', 'b5a76c6b-7323-4b6f-a7c0-f52ae1b23430', 'Bachelor of Science in Computer Science', 4.3, NOW(), NOW()),
    ('87d43292-c75f-45c7-9ff4-366d832c1563', 'ff3c59be-5397-497a-8dd1-16e0f4a5c712', 'Master of Arts in History', 4.6, NOW(), NOW()),
    ('f9b1c3c7-6a2d-4c42-b556-bc70a3f7cb1e', '26cfe037-5d95-4748-8432-1a50115db0ab', 'Master of Arts in Linguistics', 4.8, NOW(), NOW()),
    ('1f08c9dc-3b14-4d2d-bbc2-208c0c367120', 'd0d8c7e4-99ef-4a4c-a221-f43f4a2b5364', 'Doctor of Philosophy in Chemistry', 4.9, NOW(), NOW()),
    ('abc7e8f3-b79a-4f81-aa8f-8c0837d9b083', 'fc785793-fdbb-4eac-aa6f-28f8dab035f4', 'Master of Fine Arts in Creative Writing', 4.7, NOW(), NOW()),
    ('5b9c7d8f-e18b-41f2-8dd8-1fbc9db91e9b', '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', 'Bachelor of Science in Physics', 4.6, NOW(), NOW()),
    ('92f3c9b4-8108-4b3a-94e1-326e73936ad3', 'a0452d13-d78c-46de-833d-dbf88b86b03e', 'Master of Education in Teaching Mathematics', 4.5, NOW(), NOW());

CREATE TABLE assistant
(
    teacher_id   UUID NOT NULL
        CONSTRAINT teacher_id
            REFERENCES teachers,
    assistant_id UUID NOT NULL,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT assistant_id
        PRIMARY KEY (teacher_id, assistant_id)
);

INSERT INTO assistant (teacher_id, assistant_id, created_at, updated_at)
VALUES
    ('a2f2e7a5-64a9-4e53-b27d-2e4df50d9577', 'f9b1c3c7-6a2d-4c42-b556-bc70a3f7cb1e', NOW(), NOW()),
    ('c64ac722-f0f4-4b9d-a51e-d14c13dc3453', '1f08c9dc-3b14-4d2d-bbc2-208c0c367120', NOW(), NOW()),
    ('6a5b59c4-9fb8-48cb-8497-c0a996238568', 'abc7e8f3-b79a-4f81-aa8f-8c0837d9b083', NOW(), NOW()),
    ('d3e12d2b-23fd-4ae3-b3f0-b05f3dc14731', '5b9c7d8f-e18b-41f2-8dd8-1fbc9db91e9b', NOW(), NOW()),
    ('87d43292-c75f-45c7-9ff4-366d832c1563', '92f3c9b4-8108-4b3a-94e1-326e73936ad3', NOW(), NOW()),
    ('f9b1c3c7-6a2d-4c42-b556-bc70a3f7cb1e', 'a2f2e7a5-64a9-4e53-b27d-2e4df50d9577', NOW(), NOW()),
    ('1f08c9dc-3b14-4d2d-bbc2-208c0c367120', 'c64ac722-f0f4-4b9d-a51e-d14c13dc3453', NOW(), NOW()),
    ('abc7e8f3-b79a-4f81-aa8f-8c0837d9b083', '6a5b59c4-9fb8-48cb-8497-c0a996238568', NOW(), NOW()),
    ('5b9c7d8f-e18b-41f2-8dd8-1fbc9db91e9b', 'd3e12d2b-23fd-4ae3-b3f0-b05f3dc14731', NOW(), NOW()),
    ('92f3c9b4-8108-4b3a-94e1-326e73936ad3', '87d43292-c75f-45c7-9ff4-366d832c1563', NOW(), NOW());


CREATE TABLE libraries
(
    library_id UUID        NOT NULL
        CONSTRAINT library_id
            PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO libraries (library_id, name, created_at, updated_at)
VALUES
    ('6f3306af-2f8a-44fb-ae81-8bc8a0dab0e1', 'Mathematics', NOW(), NOW()),
    ('ec27690e-d1aa-485d-aa45-3e1c84eb2617', 'Astronomy', NOW(), NOW()),
    ('ad96ae03-d48e-4d20-a320-68645c3a3078', 'Art History', NOW(), NOW()),
    ('cdb3b059-22c3-4693-b1a4-738c53d0a182', 'Chemistry', NOW(), NOW()),
    ('c7a12ebd-5252-4e49-bac5-9a5a15b73dd5', 'Literature', NOW(), NOW()),
    ('5248f623-faaa-4fc2-9e8f-0723d69be1d5', 'History', NOW(), NOW()),
    ('d82f0257-9b05-4e36-9867-bfbd6cd1298e', 'Physics', NOW(), NOW()),
    ('cc90e72b-6540-468b-8fa7-d1f8e5f76a84', 'Geography', NOW(), NOW()),
    ('83a82e58-8cd2-497e-b62c-d9a0b96ed36b', 'Biology', NOW(), NOW()),
    ('49796fcf-d7a7-469b-a636-153b2bf7fe07', 'Environmental Science', NOW(), NOW());


CREATE TABLE permissions
(
    user_id     UUID
        CONSTRAINT user_id
            REFERENCES users,
    read        BOOLEAN NOT NULL,
    "create"    BOOLEAN,
    update      BOOLEAN,
    delete      BOOLEAN NOT NULL,
    resource_id UUID,
    created_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT permissions_id
        PRIMARY KEY (user_id, resource_id)
);

INSERT INTO permissions (user_id, read, "create", update, delete, resource_id, created_at, updated_at)
VALUES
    ('9a925fc9-6527-4ad3-9493-026b381db209', TRUE, TRUE, TRUE, TRUE, '6f3306af-2f8a-44fb-ae81-8bc8a0dab0e1', NOW(), NOW()),
    ('2a79305a-57e7-4e12-bd7a-13558ccdd8ae', TRUE, TRUE, TRUE, TRUE, 'ec27690e-d1aa-485d-aa45-3e1c84eb2617', NOW(), NOW()),
    ('c92319d9-69d6-48a9-bd46-ee3e41585ef7', TRUE, TRUE, TRUE, TRUE, 'ad96ae03-d48e-4d20-a320-68645c3a3078', NOW(), NOW()),
    ('26cfe037-5d95-4748-8432-1a50115db0ab', TRUE, TRUE, TRUE, TRUE, 'cdb3b059-22c3-4693-b1a4-738c53d0a182', NOW(), NOW()),
    ('ff3c59be-5397-497a-8dd1-16e0f4a5c712', TRUE, TRUE, TRUE, TRUE, 'c7a12ebd-5252-4e49-bac5-9a5a15b73dd5', NOW(), NOW()),
    ('a0452d13-d78c-46de-833d-dbf88b86b03e', TRUE, TRUE, TRUE, TRUE, '5248f623-faaa-4fc2-9e8f-0723d69be1d5', NOW(), NOW()),
    ('fc785793-fdbb-4eac-aa6f-28f8dab035f4', TRUE, TRUE, TRUE, TRUE, 'd82f0257-9b05-4e36-9867-bfbd6cd1298e', NOW(), NOW()),
    ('90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f', TRUE, TRUE, TRUE, TRUE, 'cc90e72b-6540-468b-8fa7-d1f8e5f76a84', NOW(), NOW()),
    ('9a925fc9-6527-4ad3-9493-026b381db209', TRUE, TRUE, TRUE, TRUE, '83a82e58-8cd2-497e-b62c-d9a0b96ed36b', NOW(), NOW()),
    ('c92319d9-69d6-48a9-bd46-ee3e41585ef7', TRUE, TRUE, TRUE, TRUE, '49796fcf-d7a7-469b-a636-153b2bf7fe07', NOW(), NOW());

CREATE TABLE taking_exam
(
    student_id UUID    NOT NULL
        CONSTRAINT taking_exam_students_student_id_fk
            REFERENCES students,
    exam_id    UUID    NOT NULL
        CONSTRAINT taking_exam_exams_exam_id_fk
            REFERENCES exams,
    score      NUMERIC NOT NULL,
    ranking    NUMERIC NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT taking_id
        PRIMARY KEY (student_id, exam_id)
);

INSERT INTO taking_exam (student_id, exam_id, score, ranking, created_at, updated_at)
VALUES
    ('e10b92b0-701b-4b2d-a58d-c0787be4c650', '91740c39-f802-4854-93c0-8b9a4c6a91a2', 85.0, 2, NOW(), NOW()),
    ('b6f3c79e-8147-49d8-bb43-9d8cf6a15b23', '61118bcf-22b7-49a2-8595-ec5fe57b36a0', 92.5, 1, NOW(), NOW()),
    ('91b36a3d-b310-4df3-bc1e-7f60a0863b3b', 'd0c65c0e-6710-4c51-8161-5a7606c9d66f', 78.0, 3, NOW(), NOW()),
    ('fbfb3d9a-99b5-4b5b-b0ac-c7af9f568e65', '0d51ac02-3b30-4c09-8a77-1b8d680c45c3', 87.5, 2, NOW(), NOW()),
    ('e70c68b2-af99-4ec5-b1b0-20a230422b17', '17b7b20f-3d19-4aaf-b51f-d8a62d8e15d5', 94.0, 1, NOW(), NOW()),
    ('8e99e3d1-9c1a-4d7f-bb63-24bc63b77b97', 'e209f0c9-795e-47c0-b20a-ec8257672c91', 86.5, 2, NOW(), NOW()),
    ('3af0da62-2f60-4682-ba84-92b857fbd21c', '0f21f2ed-3fc8-42a8-9069-19d66b2a6670', 90.0, 1, NOW(), NOW()),
    ('bb2e6a11-8eb8-44d4-8166-b96a9f4e9368', 'bf7c7f3e-ecaa-4e1c-b568-1ad2ff4e14e4', 88.5, 2, NOW(), NOW()),
    ('8f374d5b-57f0-468a-935b-2b4d9873fcb2', 'f4f12a20-c318-4841-a1ee-8f38eaa52e3a', 82.0, 3, NOW(), NOW()),
    ('9d3a5292-b9c3-40a8-93df-ec8d1e8d8626', '75922d7a-24c0-4bb4-b2c4-185a01616eb5', 95.0, 1, NOW(), NOW());

-- Down Migration
DROP TABLE IF EXISTS taking_exam;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS libraries;
DROP TABLE IF EXISTS assistant;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS activities;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;
DROP TYPE IF EXISTS status;
DROP TYPE IF EXISTS account_type;