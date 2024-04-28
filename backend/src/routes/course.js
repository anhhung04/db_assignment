const router = require('express').Router();
const { validate } = require("../utils/validate");
const { CourseService } = require('../services/course');
const { wrapResponse, STATUS_CODE } = require("../utils/http");
const { validate: isUUID } = require("uuid");

router.use(async (req, res, next) => {
    req.service = new CourseService(req);
    next();
});

router.param("id", async (req, res, next, id) => {
    if (!isUUID(id)) {
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_400_BAD_REQUEST,
            error: "Invalid course id",
        });
    }
    req.courseId = id;
    next();
});

router.get('/', validate({
    page: `isNumeric&optional=${JSON.stringify({ nullable: true })}`,
    limit: `isNumeric&optional=${JSON.stringify({ nullable: true })}`,
}), async (req, res) => {
    const { limit, page } = req.query;
    const courses = await req.service.listCourses({ limit, page });
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Courses fetched successfully",
        data: courses
    });
});

router.get("/:id", async (req, res) => {
    const course = await req.service.getCourseById(req.courseId);
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Course fetched successfully",
        data: course
    });
});

module.exports = router;
