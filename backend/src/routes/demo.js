const router = require('express').Router();
const { index } = require("../services/demo");

router.get('/', index);

module.exports = router;