-- Up Migration
CALL join_course('550e8400-e29b-41d4-a716-446655440014', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008');
CALL join_course('550e8400-e29b-41d4-a716-446655440011', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0005');
CALL join_course('550e8400-e29b-41d4-a716-446655440017', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009');
CALL join_course('550e8400-e29b-41d4-a716-446655440007', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012');
CALL join_course('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0013');
CALL join_course('550e8400-e29b-41d4-a716-446655440008', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0010');
CALL join_course('550e8400-e29b-41d4-a716-446655440015', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0006');
CALL join_course('550e8400-e29b-41d4-a716-446655440012', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0007');
CALL join_course('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0015');
CALL join_course('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0050');
CALL join_course('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0040');
CALL join_course('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0060');
CALL join_course('36a14986-5819-43ac-90af-b75eeb8dce27', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0011');
CALL join_course('550e8400-e29b-41d4-a716-446655440014', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0002');
CALL join_course('550e8400-e29b-41d4-a716-446655440011', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0003');
CALL join_course('550e8400-e29b-41d4-a716-446655440017', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0004');
CALL join_course('550e8400-e29b-41d4-a716-446655440007', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0014');
CALL join_course('550e8400-e29b-41d4-a716-446655440008', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0008');
CALL join_course('550e8400-e29b-41d4-a716-446655440015', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0012');
CALL join_course('550e8400-e29b-41d4-a716-446655440012', '90f5c3b5-6b82-4b6d-85b5-9c1d414e0009');

-- Down Migration
DELETE FROM students_join_courses WHERE student_id IN ('550e8400-e29b-41d4-a716-446655440014', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440017', '550e8400-e29b-41d4-a716-446655440007', '36a14986-5819-43ac-90af-b75eeb8dce27', '550e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440015', '550e8400-e29b-41d4-a716-446655440012');