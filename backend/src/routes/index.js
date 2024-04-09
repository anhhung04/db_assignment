const router = require('express').Router();
const { HTTP_200_OK } = require("../code");

router.get('/demo', (req, res) => {
    return res.status(HTTP_200_OK).json({
        message: "Hello, World!"
    });
});

module.exports = router;