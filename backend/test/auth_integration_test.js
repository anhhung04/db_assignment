const request = require('supertest');
const { app } = require('../src/server');
const { faker } = require('@faker-js/faker');

describe("POST /api/auth/login", () => {
    test("It should login successfully", async () => {
        await request(app).post('/api/auth/login').send({
            username: 'user1',
            password: 'demo'
        }).expect(200).expect((res) => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Login successfully",
                data: {
                    success: true
                }
            });
        });
    });
})

describe("Edge case", () => {
    test("It should return 401 if login failed", async () => {
        await request(app).post('/api/auth/login').send({
            username: 'user1',
            password: 'wrong_password'
        }).expect(401)
            .expect((res) => {
                expect(res.body).toEqual({
                    status_code: 401,
                    error: "Invalid username or password"
                });
            });
    });

    test("It should return 404 if route not found", async () => {
        const res = await request(app).get('/api/not-found');
        expect(res.statusCode).toEqual(404);
        expect(res.body).toEqual({
            status_code: 404,
            error: "Resource not Found"
        });
    });
})

describe("POST /api/auth/register", () => {
    test("It should return registered success after registered as a student", async () => {
        await request(app).post('/api/auth/register').send({
            username: faker.internet.userName(),
            password: faker.internet.password(),
            email: faker.internet.email(),
            phoneNo: "12345678901",
            address: faker.location.streetAddress(),
            birthday: '2004-01-01',
            fname: faker.person.firstName(),
            lname: faker.person.lastName(),
            isTeacher: false,
            studentInfo: {
                english_level: "A1",
                study_history: "I have studied English for 2 years",
                target: "I want to improve my English"
            }
        }).expect(200).expect(res => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Register successfully",
                data: {
                    success: true
                }
            });
        });
    });

    test("It should return registered success after registered as a teacher", async () => {
        await request(app).post('/api/auth/register').send({
            username: faker.internet.userName(),
            password: faker.internet.password(),
            email: faker.internet.email(),
            phoneNo: "12345678901",
            address: faker.location.streetAddress(),
            birthday: '2004-01-01',
            fname: faker.person.firstName(),
            lname: faker.person.lastName(),
            isTeacher: true,
            teacherInfo: {
                educational_level: "Bachelor"
            }
        }).expect(200).expect(res => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Register successfully",
                data: {
                    success: true
                }
            });
        });
    });
})

describe("GET /api/auth/me", () => {
    let agent = request.agent(app);

    test("should set cookie", async () => {
        await agent.post('/api/auth/login').send({
            username: 'user1',
            password: 'demo'
        }).expect(200).expect('set-cookie', /connect\.sid=.+/).expect(res => {
            expect(res.body).toEqual({
                status_code: 200,
                message: "Login successfully",
                data: {
                    success: true
                }
            });
        });
    });

    test("should get user profile", async () => {
        await agent.get('/api/auth/me').expect(200).expect(res => {
            expect(res.body).toEqual({
                status_code: 200,
                data: {
                    username: "user1",
                    email: expect.any(String),
                    created_at: expect.any(String),
                    updated_at: expect.any(String),
                    firstName: expect.any(String),
                    lastName: expect.any(String),
                    displayName: expect.any(String),
                    role: "teacher",
                    generalPermissions: {
                        "create": false,
                        "read": false,
                        "update": false,
                        "delete": false
                    },
                    "id": "90f5c3b5-6b82-4b6d-85b5-9c1d414e9a1f",
                }
            });
        });
    });
});