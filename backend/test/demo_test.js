const request = require('supertest');
const app = require('../src/server').app;

describe("Demo test", () => {
    test("It should return Hello World", async () => {
        const res = await request(app).get('/api/demo');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toEqual({ message: 'Hello, World!' });
    });
});