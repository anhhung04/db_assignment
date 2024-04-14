const router = require('express').Router();
const demoRouter = require('./demo');
const authRouter = require('./auth');

router.use('/demo', demoRouter)
router.use('/auth', authRouter)

module.exports = router;