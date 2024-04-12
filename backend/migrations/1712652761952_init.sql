-- Up Migration
create type account_type as enum ('operator', 'teacher', 'student');

alter type account_type owner to dev_user;

create type status as enum ('active', 'inactive');

alter type status owner to dev_user;

create table users
(
    username     text         not null,
    password     varchar(100) not null,
    fname        varchar(100) not null,
    lname        varchar(100) not null,
    email        varchar(100) not null,
    address      text         not null,
    id           uuid         not null
        constraint id
            primary key,
    avatar_url   text,
    account_type account_type not null,
    status       status       not null,
    manager_id   uuid,
    phone_no     varchar(11),
    birthday     date,
    created_at   timestamp,
    updated_at   timestamp
);

alter table users
    owner to dev_user;

create table students
(
    english_level varchar(50),
    study_history varchar(150),
    target        varchar(15),
    student_id    uuid not null
        constraint student_id
            primary key,
    user_id       uuid
        constraint user_id
            references users,
    created_at    timestamp,
    updated_at    timestamp
);

alter table students
    owner to dev_user;

create table activities
(
    activity_id uuid not null
        constraint activity_id
            primary key,
    occur_at    timestamp,
    created_by  varchar(50),
    action      varchar(50),
    dest        varchar(50),
    note        varchar(100),
    user_id     uuid
        constraint user_id
            references users,
    created_at  timestamp,
    updated_at  timestamp
);

alter table activities
    owner to dev_user;

create table exams
(
    exam_id    uuid    not null
        constraint exam_id
            primary key,
    questions  text    not null,
    answers    text    not null,
    duration   integer not null,
    library_id uuid    not null,
    create_at  timestamp,
    "publish " date    not null,
    update_at  timestamp
);

alter table exams
    owner to dev_user;

create table teachers
(
    teacher_id        uuid not null
        constraint teacher_id
            primary key,
    user_id           uuid not null
        constraint user_id
            references users,
    educational_level text,
    rating            double precision,
    created_at        timestamp,
    updated_at        timestamp
);

alter table teachers
    owner to dev_user;

create table assistant
(
    teacher_id   uuid not null
        constraint teacher_id
            references teachers,
    assistant_id uuid not null,
    created_at   timestamp,
    updated_at   timestamp,
    constraint assistant_id
        primary key (teacher_id, assistant_id)
);

alter table assistant
    owner to dev_user;

create table libraries
(
    library_id uuid        not null
        constraint library_id
            primary key,
    name       varchar(50) not null,
    create_at  timestamp,
    update_at  timestamp
);

alter table libraries
    owner to dev_user;

create table permissions
(
    user_id     uuid
        constraint user_id
            references users,
    read        boolean not null,
    "create"    boolean,
    update      boolean,
    delete      boolean not null,
    resource_id uuid,
    create_at   timestamp,
    update_at   timestamp
);

alter table permissions
    owner to dev_user;

create table taking_exam
(
    student_id uuid    not null
        constraint taking_exam_students_student_id_fk
            references students,
    exam_id    uuid    not null
        constraint taking_exam_exams_exam_id_fk
            references exams,
    score      numeric not null,
    ranking    numeric not null,
    create_at  timestamp,
    update_at  timestamp,
    constraint taking_id
        primary key (student_id, exam_id)
);

alter table taking_exam
    owner to dev_user;
-- Down Migration