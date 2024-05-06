-- Up Migration
INSERT INTO documents (id, material, author, format, type) VALUES ('2a57e3e0-d309-4e91-8fc8-f9d45a23b2d5', 'English Course - French-English Dictionary', 'Sophie Martin', 'PDF', 'dictionary');
INSERT INTO documents (id, material, author, format, type) VALUES ('9d6e81b3-57b3-4e08-b6d2-0a72b022f09f', 'English Course - TOEFL Practice Tests', 'Daniel White', 'DOCX', 'mock_test');
INSERT INTO documents (id, material, author, format, type) VALUES ('458db32c-2baf-437d-91c3-8d33db27c7d1', 'English Course - Art History: From Renaissance to Modern Art', 'Olivia Brown', 'PDF', 'book');
INSERT INTO documents (id, material, author, format, type) VALUES ('d30500e8-4b3f-4fd0-9f5d-6a0ccfdd2fe5', 'English Course - SAT Practice Questions', 'Isabella Smith', 'DOCX', 'mock_test');
INSERT INTO documents (id, material, author, format, type) VALUES ('6aa6c58b-6897-4549-8835-1c6e2b4d109d', 'English Course - IELTS Preparation Course', 'Liam Wilson', 'PDF', 'book');
INSERT INTO documents (id, material, author, format, type) VALUES ('57bb0eeb-30f2-4d8b-a77e-5f189bda5363', 'English Course - German-English Dictionary', 'Hannah Mueller', 'EPUB', 'dictionary');
INSERT INTO documents (id, material, author, format, type) VALUES ('eaf5b539-6b12-4e9d-9583-68c69509c79e', 'English Course - Pronunciation', 'Emily Davis', 'EPUB', 'book');
INSERT INTO documents (id, material, author, format, type) VALUES ('7f85b42d-5fa9-4ef1-a9cb-fb609d4b412a', 'English Course - Advanced Grammar', 'Michael Johnson', 'PDF', 'book');
INSERT INTO documents (id, material, author, format, type) VALUES ('1f65e0f9-f1d1-43e5-b545-094e6a7e2746', 'English Course - English Grammar Guide', 'Carlos Rodriguez', 'EPUB', 'book');
INSERT INTO documents (id, material, author, format, type) VALUES ('c2293626-1650-4542-9077-fc267f666fe4', 'English Course - Statistics Listening', 'Emma Thompson', 'PDF', 'book');
-- Down Migration
DELETE FROM documents WHERE id IN ('2a57e3e0-d309-4e91-8fc8-f9d45a23b2d5', '9d6e81b3-57b3-4e08-b6d2-0a72b022f09f', '458db32c-2baf-437d-91c3-8d33db27c7d1', 'd30500e8-4b3f-4fd0-9f5d-6a0ccfdd2fe5', '6aa6c58b-6897-4549-8835-1c6e2b4d109d', '57bb0eeb-30f2-4d8b-a77e-5f189bda5363', 'eaf5b539-6b12-4e9d-9583-68c69509c79e', '7f85b42d-5fa9-4ef1-a9cb-fb609d4b412a', '1f65e0f9-f1d1-43e5-b545-094e6a7e2746', 'c2293626-1650-4542-9077-fc267f666fe4');