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
                data: expect.any(Object)
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
        }).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Course updated successfully",
                data: expect.any(Object)
            });
        });
    });
});