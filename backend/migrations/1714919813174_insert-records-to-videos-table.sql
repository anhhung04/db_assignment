-- Up Migration
INSERT INTO videos (id, description, duration) VALUES ('002880c4-deea-4892-892a-b9d5082d111c', e'Everyday English Conversations Practice Easy.
Everyday English Listening and Speaking - Listen and Speak English Like a Native.', 42);
INSERT INTO videos (id, description, duration) VALUES ('74affdbb-f1a3-4a25-9821-72baa3b3d518', e'Practice English Conversation by Topics.
Daily English Speaking Practice.', 60);
INSERT INTO videos (id, description, duration) VALUES ('e831c32c-d930-4a25-9d41-cf3c3f5eeb78', 'English Conversation for Daily Life - Speak English Fluently and Confidently.', 108);
INSERT INTO videos (id, description, duration) VALUES ('bad2b64e-b4d3-4031-923f-576ce6df88a1', 'Listen To Real English Conversation Practice - Learning English Conversation: Listen & Practice.', 80);
-- Down Migration
DELETE FROM videos WHERE id IN ('002880c4-deea-4892-892a-b9d5082d111c', '74affdbb-f1a3-4a25-9821-72baa3b3d518', 'e831c32c-d930-4a25-9d41-cf3c3f5eeb78', 'bad2b64e-b4d3-4031-923f-576ce6df88a1');