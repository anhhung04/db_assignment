/* eslint-disable */
const request = require('supertest');
const { app } = require('../src/server');
const { faker } = require('@faker-js/faker');

describe("Test course service", () => {
    let agent = request.agent(app);
    test("It should login as teacher", async () => {
        await agent.post('/api/auth/login').send({
            username: "user1",
            password: "demo"
        }).expect(200);
    });
    test("It should create new course", async () => {
        await agent.post('/api/course').send({
            title: faker.lorem.words(),
            type: ["free", "paid"][Math.floor(Math.random() * 2)],
            description: faker.lorem.sentence(),
            level: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'][Math.floor(Math.random() * 6)],
            thumbnail_url: faker.image.url(),
            headline: faker.lorem.sentence(),
            content_info: ["ielts", "toeic", "communicate"][Math.floor(Math.random() * 3)],
            amount_price: (Math.random() * 1000).toFixed(2),
            currency: "usd"
        }).expect(201).expect((res) => {
            expect(res.body).toEqual({
                status_code: 201,
                message: "Course created successfully",
            });
        });
    });

    test("It should list courses", async () => {
        await agent.get('/api/course').expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Courses fetched successfully",
                data: expect.any(Array)
            });
        });
    });

    test("It should find course by slug", async () => {
        let course = {};
        await agent.get('/api/course').expect(200).expect((res) => {
            course = res.body.data[0];
        });
        await agent.get(`/api/course/${course.course_slug}`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Course fetched successfully",
                data: expect.any(Object)
            });
        });
    });

    test("It should return courses with a in title", async () => {
        await agent.get('/api/course/search?content=YQ').expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Courses fetched successfully",
                data: expect.any(Array)
            });
        });
    });

    test("It should update course", async () => {
        let course = {};
        await agent.get('/api/course').expect(200).expect((res) => {
            course = res.body.data[0];
        });
        await agent.patch(`/api/course/${course.course_id}`).send({
            type: ["free", "paid"][Math.floor(Math.random() * 2)],
            description: faker.lorem.sentence(),
            level: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'][Math.floor(Math.random() * 6)],
            thumbnail_url: faker.image.url(),
            headline: faker.lorem.sentence(),
            content_info: ["ielts", "toeic", "communicate"][Math.floor(Math.random() * 3)],
            amount_price: (Math.random() * 1000).toFixed(2),
            currency: "usd"
        }).expect(200)
    });
});


describe("Test lesssons service", () => {
    let agent = request.agent(app);
    let course = {};
    test("It should login as teacher", async () => {
        await agent.post('/api/auth/login').send({
            username: "user1",
            password: "demo"
        }).expect(200);
    });

    test("It should list courses", async () => {
        await agent.get('/api/course').expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Courses fetched successfully",
                data: expect.any(Array)
            });
        });
    });

    test("It should find course by slug", async () => {
        await agent.get('/api/course').expect(200).expect((res) => {
            course = res.body.data[0];
        });
        await agent.get(`/api/course/${course.course_slug}`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Course fetched successfully",
                data: expect.any(Object)
            });
        });
    });

    test("It should create new lesson using course id", async () => {
        await agent.post(`/api/course/${course.course_id}/lesson`).send({
            title: faker.lorem.words(),
            description: faker.lorem.sentence(),
        }).expect(201).expect((res) => {
            expect(res.body).toEqual({
                status_code: 201,
                message: "Lesson created successfully",
                data: expect.any(Object)
            });
        });
    });

    test("It should list lessons using course id", async () => {
        await agent.get(`/api/course/${course.course_id}/lesson`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Lessons fetched successfully",
                data: expect.any(Array)
            });
        });
    });

    test("It should list lessons using course slug", async () => {
        await agent.get(`/api/course/${course.course_slug}/lesson`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Lessons fetched successfully",
                data: expect.any(Array)
            });
        });
    });

    let lessonId = "";
    test("It should create new lesson using course id", async () => {
        await agent.post(`/api/course/${course.course_id}/lesson`).send({
            title: faker.lorem.words(),
            description: faker.lorem.sentence(),
        }).expect(201).expect((res) => {
            lessonId = res.body.data.id;
        });
    });

    test("It should update lesson", async () => {
        await agent.patch(`/api/course/lesson/${lessonId}`).send({
            title: faker.lorem.words(),
            description: faker.lorem.sentence(),
        }).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Lesson updated successfully",
                data: expect.any(Object)
            });
        });
    });
});

describe("Test student course service", () => {
    let agent = request.agent(app);
    let course = {};
    test("It should login as student", async () => {
        await agent.post('/api/auth/login').send({
            username: "user2",
            password: "demo"
        }).expect(200);
    });

    test("It should list courses", async () => {
        await agent.get('/api/course').expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Courses fetched successfully",
                data: expect.any(Array)
            });
        });
    });

    test("It should find course by slug", async () => {
        await agent.get('/api/course').expect(200).expect((res) => {
            course = res.body.data[0];
        });
        await agent.get(`/api/course/${course.course_slug}`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Course fetched successfully",
                data: expect.any(Object)
            });
        });
    });

    test("It should find course by id", async () => {
        let course = {};
        await agent.get('/api/course').expect(200).expect((res) => {
            course = res.body.data[0];
        });
        await agent.get(`/api/course/${course.course_id}`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Course fetched successfully",
                data: expect.any(Object)
            });
        });
    });
});

describe("Test resource service", () => {
    let agent = request.agent(app);
    let course = {};
    let lessonId = "";
    test("It should login as teacher", async () => {
        await agent.post('/api/auth/login').send({
            username: "user1",
            password: "demo"
        }).expect(200);
    });
    test("It should find course by id", async () => {
        await agent.get('/api/course').expect(200).expect((res) => {
            course = res.body.data[0];
        });
        await agent.get(`/api/course/${course.course_id}`).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Course fetched successfully",
                data: expect.any(Object)
            });
        });
    });
    test("It should create new lesson using course id", async () => {
        await agent.post(`/api/course/${course.course_id}/lesson`).send({
            title: faker.lorem.words(),
            description: faker.lorem.sentence(),
        }).expect(201).expect((res) => {
            lessonId = res.body.data.id;
        });
    });

    test("It should create new video resource", async () => {
        await agent.post(`/api/resource/videos?lessonId=${lessonId}`).send({
            title: faker.lorem.words(),
            download_url: faker.image.url(),
            description: faker.lorem.sentence(),
            duration: 600
        }).expect(201).expect((res) => {
            expect(res.body).toEqual({
                status_code: 201,
                message: "Video created successfully",
                data: expect.any(Object)
            });
        });
    });

    test("It should create new document resource", async () => {
        await agent.post(`/api/resource/documents?lessonId=${lessonId}`).send({
            title: faker.lorem.words(),
            download_url: faker.image.url(),
            material: faker.lorem.sentence(),
        });
    });

    test("It should fetch video resource", async () => {
        let lessons = [];
        await agent.get(`/api/course/${course.course_id}/lesson`).expect(200).expect((res) => {
            lessons = res.body.data;
        });
        for (let lesson of lessons) {
            for (let resource of lesson.resources) {
                if (resource.resource_id) {
                    await agent.get(`/api/resource/videos/${resource.resource_id}`).expect(200).expect((res) => {
                        expect(res.body).toEqual({
                            status_code: 200,
                            message: "Video fetched successfully",
                            data: expect.any(Object)
                        });
                    });
                }
            }
        }
    });
});