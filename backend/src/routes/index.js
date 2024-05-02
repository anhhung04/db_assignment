const router = require('express').Router();
const authRouter = require('./auth');
const courseRouter = require('./course');
const resourceRouter = require('./resource');

router.use('/auth', authRouter)
router.use('/course', courseRouter)
router.use('/resource', resourceRouter)

module.exports = router;