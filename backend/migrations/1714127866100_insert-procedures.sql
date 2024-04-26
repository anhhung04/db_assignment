-- Up Migration
CREATE OR REPLACE PROCEDURE display_user_names()
AS $$
BEGIN
    UPDATE users SET display_name = CONCAT(lname, ' ', fname)
    WHERE display_name IS NULL OR display_name = '';
END;
$$ LANGUAGE plpgsql;
--CALL display_user_names();

-- Down Migration