/* eslint-disable */
const { downAll } = require('docker-compose/dist/v2');
const { redisClient } = require("./src/server");
const { pool } = require("./src/repository");
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
afterEach(async () => {
    jest.clearAllMocks();
    jest.resetAllMocks();
    jest.resetModules();
    await redisClient.disconnect();
});

afterAll(async () => {
    await pool.end();
    // await downAll({
    //     cwd: __dirname + '/test_setup',
    //     log: true
    // });
});