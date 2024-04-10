const router = require('express').Router();
const demoRouter = require('./demo');

router.use('/demo', demoRouter)

module.exports = router;