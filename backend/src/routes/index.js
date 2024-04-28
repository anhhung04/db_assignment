const router = require('express').Router();
const demoRouter = require('./demo');
const authRouter = require('./auth');
const courseRouter = require('./course');

router.use('/demo', demoRouter)
router.use('/auth', authRouter)
router.use('/course', courseRouter)

module.exports = router;