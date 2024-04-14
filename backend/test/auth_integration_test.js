const request = require('supertest');
const { app } = require('../src/server');
const { faker } = require('@faker-js/faker');

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

test("It should return registered success", async () => {
    await request(app).post('/api/auth/register').send({
        username: faker.internet.userName(),
        password: faker.internet.password(),
        email: faker.internet.email(),
        phone_no: "12345678901",
        address: faker.location.streetAddress(),
        birthday: '2004-01-01',
        fname: faker.person.firstName(),
        lname: faker.person.lastName(),
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

test("It should return user info after login", async () => {
    const res = await request(app).post('/api/auth/login').send({
        username: 'user1',
        password: 'demo'
    }).expect(200);
    const cookie = res.headers['set-cookie'];
    const res2 = await request(app).get('/api/auth/me').set('Cookie', cookie[0]);
    expect(res2.statusCode).toEqual(200);
    expect(res2.body).toEqual({
        status_code: 200,
        data: {
            id: expect.any(String),
            username: 'user1',
            email: expect.any(String),
            firstName: expect.any(String),
            lastName: expect.any(String),
            generalPermissions: {
                read: null,
                create: null,
                delete: null,
                update: null
            },
            role: 'teacher',
            created_at: expect.any(String),
            updated_at: expect.any(String)
        }
    });
});