const router = require('express').Router();
const { validate } = require("../utils/validate");
const { CourseService } = require('../services/course');
const { wrapResponse, STATUS_CODE } = require("../utils/http");
const { validate: isUUID } = require("uuid");
const { UserRole, ActionType } = require("../utils/service");
router.use(async (req, res, next) => {
    req.service = new CourseService(req);
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

router.get("/search", validate({
    content: "isString",
    limit: `isNumeric&optional=${JSON.stringify({ nullable: true })}`,
}), async (req, res) => {
    let { content, limit } = req.query;
    content = String(atob(content));
    const courses = await req.service.searchCourses({ content, limit });
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Courses fetched successfully",
        data: courses
    });
});


router.get("/:id", async (req, res) => {
    let isSlug = !isUUID(String(req.params.id));
    const course = await req.service.findCourse(String(req.params.id), isSlug);
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Course fetched successfully",
        data: course
    });
});

router.post("/", validate({
    title: "isString",
    type: "isString",
    description: "isString",
    level: "isString",
    thumbnail_url: `isString&optional=${JSON.stringify({ nullable: true })}`,
    headline: "isString",
    content_info: "isString",
    amount_price: "isNumeric",
    currency: "isString",
}), async (req, res) => {
    let {
        title,
        type,
        description,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency
    } = req.body;
    const course = await req.service.createCourse({
        title,
        type,
        description,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        acl: [UserRole.TEACHER]
    });
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_201_CREATED,
        message: "Course created successfully",
        data: course
    });
});

router.patch("/:id", validate({
    type: `isString&optional=${JSON.stringify({ nullable: true })}`,
    description: `isString&optional=${JSON.stringify({ nullable: true })}`,
    level: `isString&optional=${JSON.stringify({ nullable: true })}`,
    thumbnail_url: `isString&optional=${JSON.stringify({ nullable: true })}`,
    headline: `isString&optional=${JSON.stringify({ nullable: true })}`,
    content_info: `isString&optional=${JSON.stringify({ nullable: true })}`,
    amount_price: `isNumeric&optional=${JSON.stringify({ nullable: true })}`,
    currency: `isString&optional=${JSON.stringify({ nullable: true })}`,
}), async (req, res) => {
    if (!isUUID(String(req.params.id))) {
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_400_BAD_REQUEST,
            message: "Invalid course id"
        });
    }
    let {
        type,
        description,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency
    } = req.body;
    let courseId = String(req.params.id);
    const course = await req.service.updateCourse(courseId, {
        type,
        description,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency,
        resourceId: courseId,
        actionType: ActionType.UPDATE
    });
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Course updated successfully",
        data: course
    });
});

module.exports = router;
