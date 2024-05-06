-- Up Migration
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0002',
        'Khóa Học Tiếng Anh Cơ Bản',
        'paid',
        'Học cách sử dụng ngữ pháp cơ bản và giao tiếp tiếng Anh hàng ngày.',
        0,
        'A2',
        'http://example.com/thumbnail_2.jpg',
        'Khóa Học Tiếng Anh Cơ Bản',
        'Basic',
        19.99,
        'vnd',
        'khoa-hoc-tieng-anh-co-ban',
        50,
        200,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0003',
        'Khóa Học Tiếng Anh Giao Tiếp Sơ Cấp',
        'free',
        'Học cách giao tiếp tiếng Anh cơ bản trong các tình huống hàng ngày.',
        0,
        'A1',
        'http://example.com/thumbnail_3.jpg',
        'Khóa Học Tiếng Anh Giao Tiếp Sơ Cấp',
        'Basic',
        0,
        'vnd',
        'khoa-hoc-tieng-anh-giao-tiep-so-cap',
        20,
        100,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0004',
        'Khóa Học Tiếng Anh Phrasal Verbs',
        'paid',
        'Học cách sử dụng phrasal verbs một cách hiệu quả trong tiếng Anh.',
        0,
        'B1',
        'http://example.com/thumbnail_4.jpg',
        'Khóa Học Tiếng Anh Phrasal Verbs',
        'Intermediate',
        24.99,
        'eur',
        'khoa-hoc-tieng-anh-phrasal-verbs',
        40,
        180,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005',
        'Khóa Học Tiếng Anh Kinh Doanh',
        'paid',
        'Học cách sử dụng tiếng Anh trong môi trường kinh doanh và giao dịch quốc tế.',
        0,
        'B2',
        'http://example.com/thumbnail_5.jpg',
        'Khóa Học Tiếng Anh Kinh Doanh',
        'Advanced',
        29.99,
        'vnd',
        'khoa-hoc-tieng-anh-kinh-doanh',
        70,
        250,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006',
        'Khóa Học Tiếng Anh Học Thuật',
        'paid',
        'Học cách đọc, viết và nói tiếng Anh trong lĩnh vực học thuật và nghiên cứu.',
        0,
        'C1',
        'http://example.com/thumbnail_6.jpg',
        'Khóa Học Tiếng Anh Học Thuật',
        'Advanced',
        34.99,
        'usd',
        'khoa-hoc-tieng-anh-hoc-thuat',
        60,
        220,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0007',
        'Khóa Học Tiếng Anh Giao Tiếp Nâng Cao',
        'paid',
        'Nâng cao kỹ năng giao tiếp tiếng Anh trong các tình huống phức tạp.',
        0,
        'B2',
        'http://example.com/thumbnail_7.jpg',
        'Khóa Học Tiếng Anh Giao Tiếp Nâng Cao',
        'Advanced',
        39.99,
        'vnd',
        'khoa-hoc-tieng-anh-giao-tiep-nang-cao',
        80,
        300,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008',
        'Khóa Học Tiếng Anh Phản Xạ',
        'paid',
        'Tìm hiểu về cấu trúc và sử dụng của động từ phản xạ trong tiếng Anh.',
        0,
        'B1',
        'http://example.com/thumbnail_8.jpg',
        'Khóa Học Tiếng Anh Phản Xạ',
        'Intermediate',
        24.99,
        'vnd',
        'khoa-hoc-tieng-anh-phan-xa',
        30,
        120,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009',
        'Khóa Học Tiếng Anh Hội Thoại Du Lịch',
        'paid',
        'Học cách giao tiếp tiếng Anh trong các tình huống du lịch và khám phá văn hóa.',
        0,
        'A2',
        'http://example.com/thumbnail_9.jpg',
        'Khóa Học Tiếng Anh Hội Thoại Du Lịch',
        'Basic',
        19.99,
        'vnd',
        'khoa-hoc-tieng-anh-hoi-thoai-du-lich',
        50,
        200,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010',
        'Khóa Học Tiếng Anh Phát Âm Chuẩn',
        'paid',
        'Hướng dẫn cách phát âm tiếng Anh chuẩn và cải thiện khả năng nghe hiểu.',
        0,
        'A2',
        'http://example.com/thumbnail_10.jpg',
        'Khóa Học Tiếng Anh Phát Âm Chuẩn',
        'Basic',
        29.99,
        'eur',
        'khoa-hoc-tieng-anh-phat-am-chuan',
        40,
        180,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0011',
        'Khóa Học Tiếng Anh Kỹ Năng Viết',
        'free',
        'Nâng cao kỹ năng viết tiếng Anh qua các bài tập và thực hành.',
        0,
        'B1',
        'http://example.com/thumbnail_11.jpg',
        'Khóa Học Tiếng Anh Kỹ Năng Viết',
        'Intermediate',
        0,
        'usd',
        'khoa-hoc-tieng-anh-ky-nang-viet',
        60,
        220,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012',
        'Khóa Học Tiếng Anh Luyện Nghe',
        'paid',
        'Tập trung vào việc cải thiện khả năng nghe tiếng Anh thông qua các bài tập và bài nghe thực tế.',
        0,
        'B1',
        'http://example.com/thumbnail_12.jpg',
        'Khóa Học Tiếng Anh Luyện Nghe',
        'Intermediate',
        14.99,
        'vnd',
        'khoa-hoc-tieng-anh-luyen-nghe',
        30,
        150,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0013',
        'Khóa Học Tiếng Anh Giao Tiếp Thương Mại',
        'paid',
        'Học cách giao tiếp tiếng Anh trong môi trường thương mại và giao dịch kinh doanh.',
        0,
        'B2',
        'http://example.com/thumbnail_13.jpg',
        'Khóa Học Tiếng Anh Giao Tiếp Thương Mại',
        'Advanced',
        29.99,
        'vnd',
        'khoa-hoc-tieng-anh-giao-tiep-thuong-mai',
        70,
        250,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0014',
        'Khóa Học Tiếng Anh Ngữ Pháp Nâng Cao',
        'paid',
        'Nắm vững và áp dụng ngữ pháp tiếng Anh nâng cao trong việc viết và nói.',
        0,
        'C1',
        'http://example.com/thumbnail_14.jpg',
        'Khóa Học Tiếng Anh Ngữ Pháp Nâng Cao',
        'Advanced',
        34.99,
        'usd',
        'khoa-hoc-tieng-anh-ngu-phap-nang-cao',
        60,
        220,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
INSERT INTO courses (
        course_id,
        title,
        type,
        description,
        rating,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        course_slug,
        access_count,
        total_students,
        created_at,
        updated_at,
        teacher_id
    )
VALUES (
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e0015',
        'Khóa Học Tiếng Anh Chuyên Ngành Y Khoa',
        'paid',
        'Học cách sử dụng tiếng Anh trong lĩnh vực y khoa và giao tiếp với bệnh nhân.',
        0,
        'B2',
        'http://example.com/thumbnail_15.jpg',
        'Khóa Học Tiếng Anh Chuyên Ngành Y Khoa',
        'Advanced',
        39.99,
        'vnd',
        'khoa-hoc-tieng-anh-chuyen-nganh-y-khoa',
        80,
        300,
        '2024-05-04 10:00:00.000000',
        '2024-05-04 10:00:00.000000',
        '90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f'
    );
-- Down Migration
DELETE FROM courses WHERE course_id IN ('90f5c3b5-6b82-4b6d-85b5-9c1d414e0002', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0003', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0004', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0007', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0011', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0013', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0014', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0015');