const router = require('express').Router();
const { DemoService } = require("../services/demo");
const { wrapResponse, STATUS_CODE } = require('../utils/http');
const { validate } = require("../utils/validate")

router.use((req, _, next) => {
    req.service = new DemoService(req);
    next();
});

router.get('/', async (req, res, next) => {
    try {
        const service = req.service;
        let result = await service.index();
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Fetch data successfully",
            data: {
                message: result
            }
        });
    } catch (err) {
        next(err);
    }
});

router.post('/validate', validate({
    itMustBeEmail: "isEmail",
    username: `not&isEmpty&isLength=${JSON.stringify({ min: 6, max: 10 })}`,
    user: {
        password: "not&isEmpty",
    }
}), async (req, res) => {
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Fetch data successfully",
        data: {
            body: req.body,
            result: "validate ok!"
        }
    });
})

module.exports = router;