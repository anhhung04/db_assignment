const express = require('express');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const cors = require('cors');
const process = require('node:process');
const crypto = require('crypto');
const cookieSecret = crypto.randomBytes(128).toString('base64');
const { HTTP_404_NOT_FOUND, HTTP_500_INTERNAL_SERVER_ERROR } = require('./code');

const redis = require('redis');
const RedisStore = require('connect-redis').default;
const redisClient = redis.createClient({
    url: process.env.REDIS_URL || 'redis://redis:6379'
});

require('dotenv').config();
const app = express();
const mainRoute = require('./routes');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser(cookieSecret));

app.use(cors());

app.use(session({
    secret: cookieSecret,
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: process.env.NODE_ENV === 'production',
        httpOnly: true,
        maxAge: 1000 * 60 * 60,
    },
    store: new RedisStore({
        client: redisClient
    }),
}));

app.use('/api', mainRoute);

app.all('*', (req, res) => {
    return res.status(HTTP_404_NOT_FOUND).json({
        error: 'Not Found',
    });
});

app.use(function (err, req, res, next) {
    next(res.status(HTTP_500_INTERNAL_SERVER_ERROR).json({
        error: 'Internal Server Error',
    }));
});

module.exports = {
    app,
    redisClient
};