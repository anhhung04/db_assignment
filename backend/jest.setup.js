/* eslint-disable */
const { downAll } = require('docker-compose/dist/v2');
const { redisClient } = require("./src/server");
require('dotenv').config({
    path: '.env.test'
});

process.env.ENVIRONMENT_NAME = 'test';
beforeEach(async () => {
    process.env = { ...process.env, ENVIRONMENT_NAME: 'test' };
    try {
        if (!redisClient.isOpen) {
            await redisClient.connect();
        }
    } catch (e) {
        console.error(e);
    }
});
afterEach(() => {
    jest.clearAllMocks();
    jest.resetAllMocks();
    jest.resetModules();
});

afterAll(async () => {
    await redisClient.disconnect();
});