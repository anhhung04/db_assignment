-- Start Insert_course function
CREATE OR REPLACE FUNCTION insert_course(
    p_course_id UUID,
    p_title VARCHAR(50),
    p_type course_type,
    p_description VARCHAR(200),
    p_rating DOUBLE PRECISION,
    p_price DECIMAL,
    p_level level_type,
    p_thumbnail_url TEXT,
    p_headline VARCHAR(100),
    p_content_info VARCHAR(20),
    p_amount DOUBLE PRECISION,
    p_currency currency_type,
    p_title_slug VARCHAR(100)
) RETURNS VOID AS $$
BEGIN
    -- Kiểm tra dữ liệu hợp lệ
    IF p_price <= 0 THEN
        RAISE EXCEPTION 'Lỗi: Giá không hợp lệ!';
    ELSE
        -- Thêm dữ liệu vào bảng courses
        INSERT INTO courses (course_id, title, type, description, rating, price, level, thumbnail_url, headline, content_info, amount, currency, title_slug)
        VALUES (p_course_id, p_title, p_type, p_description, p_rating, p_price, p_level, p_thumbnail_url, p_headline, p_content_info, p_amount, p_currency, p_title_slug);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- End Insert_course function

