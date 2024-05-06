-- Up Migration
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('f80e84bf-2bf5-4eb1-bd5e-94d92a3e5f31', '002880c4-deea-4892-892a-b9d5082d111c', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('f80e84bf-2bf5-4eb1-bd5e-94d92a3e5f31', '458db32c-2baf-437d-91c3-8d33db27c7d1', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('303187a1-d5e0-4c8c-b7d3-50a134aa6f25', '74affdbb-f1a3-4a25-9821-72baa3b3d518', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('303187a1-d5e0-4c8c-b7d3-50a134aa6f25', '6aa6c58b-6897-4549-8835-1c6e2b4d109d', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('fc07812a-dfd2-40e1-a0cc-8b0487a4b35f', 'e831c32c-d930-4a25-9d41-cf3c3f5eeb78', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('fc07812a-dfd2-40e1-a0cc-8b0487a4b35f', '9d6e81b3-57b3-4e08-b6d2-0a72b022f09f', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('9f3c7f1d-bf41-46d0-9a02-6b9a68c25510', 'bad2b64e-b4d3-4031-923f-576ce6df88a1', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('9f3c7f1d-bf41-46d0-9a02-6b9a68c25510', '1f65e0f9-f1d1-43e5-b545-094e6a7e2746', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('75830cbb-f2fd-4f27-b2c3-cf0a564ef207', 'c2293626-1650-4542-9077-fc267f666fe4', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('c8b4a05b-01bb-4ac5-9d42-0e5da93b0f14', '002880c4-deea-4892-892a-b9d5082d111c', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('c8b4a05b-01bb-4ac5-9d42-0e5da93b0f14', '2a57e3e0-d309-4e91-8fc8-f9d45a23b2d5', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('16f3c5f4-4950-41cf-82e1-c9b6d17ee812', 'bad2b64e-b4d3-4031-923f-576ce6df88a1', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('16f3c5f4-4950-41cf-82e1-c9b6d17ee812', '7f85b42d-5fa9-4ef1-a9cb-fb609d4b412a', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('db4d7f30-ae3e-4542-8ae4-f55e374f49c8', '002880c4-deea-4892-892a-b9d5082d111c', 'videos');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('db4d7f30-ae3e-4542-8ae4-f55e374f49c8', 'd30500e8-4b3f-4fd0-9f5d-6a0ccfdd2fe5', 'documents');
INSERT INTO lesson_resources (lesson_id, resource_id, resource_type) VALUES ('75830cbb-f2fd-4f27-b2c3-cf0a564ef207', '57bb0eeb-30f2-4d8b-a77e-5f189bda5363', 'documents');

-- Down Migration
DELETE FROM lesson_resources WHERE lesson_id IN ('f80e84bf-2bf5-4eb1-bd5e-94d92a3e5f31', '303187a1-d5e0-4c8c-b7d3-50a134aa6f25', 'fc07812a-dfd2-40e1-a0cc-8b0487a4b35f', '9f3c7f1d-bf41-46d0-9a02-6b9a68c25510', '75830cbb-f2fd-4f27-b2c3-cf0a564ef207', 'c8b4a05b-01bb-4ac5-9d42-0e5da93b0f14', '16f3c5f4-4950-41cf-82e1-c9b6d17ee812', 'db4d7f30-ae3e-4542-8ae4-f55e374f49c8');