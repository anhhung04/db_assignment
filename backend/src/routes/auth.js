const router = require('express').Router();
const { AuthService } = require('../services/auth');
const { wrapResponse, STATUS_CODE, saveSession } = require('../utils/http');
const { HTTPException } = require('../utils/error');
const { validate } = require('../utils/validate');

router.use(async (req, res, next) => {
    try {
        Object.assign(req, { authService: new AuthService(req) });
        next()
    } catch (err) {
        next(err);
    }
});

router.post('/login', validate({
    username: `optional=${JSON.stringify({ nullable: true })}&isString`,
    email: `optional=${JSON.stringify({ nullable: true })}&isEmail`,
    password: "not&isEmpty&isString"
}), async (req, res, next) => {
    try {
        const { username, password, email } = req.body;
        /**
         * @type {AuthService}
         */
        const authService = req.authService;
        const user = await authService.login({ username, password, email });
        if (!user) {
            throw new HTTPException({
                code: STATUS_CODE.HTTP_401_UNAUTHORIZED,
                message: "Invalid username or password",
                data: {
                    success: false
                }
            });
        }
        await saveSession(req, { user });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Login successfully",
            data: {
                success: true
            }
        });
    } catch (err) {
        next(err);
    }
});

router.post('/register', validate({
    username: "isString",
    email: "isEmail",
    password: "isString",
    phoneNo: "isString",
    address: "isString",
    avatarUrl: `isString&optional=${JSON.stringify({ nullable: true })}`,
    birthday: `isISO8601=${JSON.stringify('yyyy-mm-dd')}`,
    fname: "isString",
    lname: "isString",
    isTeacher: "isBoolean",
    teacherInfo: {
        educational_level: `isString&optional=${JSON.stringify({ nullable: true })}`,
    },
    studentInfo: {
        study_history: `isString&optional=${JSON.stringify({ nullable: true })}`,
        english_level: `isString&optional=${JSON.stringify({ nullable: true })}`,
        target: `isString&optional=${JSON.stringify({ nullable: true })}`,
    }

}), async (req, res, next) => {
    try {
        const {
            username,
            password,
            email,
            phone_no,
            address,
            avatarUrl: avatar_url,
            birthday,
            fname,
            lname
        } = req.body;
        let isTeacher = req.body.isTeacher;
        let data = {};
        if (isTeacher) {
            data = {
                educational_level: req.body.teacherInfo.educational_level
            };
        } else {
            data = {
                study_history: req.body.studentInfo.study_history,
                english_level: req.body.studentInfo.english_level,
                target: req.body.studentInfo.target
            };
        }
        /**
         * @type {AuthService}
         */
        const authService = req.authService;
        await authService.register({
            username,
            password,
            email,
            phone_no,
            address,
            avatar_url,
            birthday,
            fname,
            lname,
            isTeacher,
            data
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Register successfully",
            data: {
                success: true
            }
        });
    } catch (err) {
        next(err);
    }
});

router.get("/me", async (req, res, next) => {
    try {
        const user = req.session?.user;
        if (!user) {
            throw new HTTPException({
                code: STATUS_CODE.HTTP_401_UNAUTHORIZED,
                message: "Unauthorized",
            });
        }
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            data: user
        });
    } catch (err) {
        next(err);
    }
});

module.exports = router;