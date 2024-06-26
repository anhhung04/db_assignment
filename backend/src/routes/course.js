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
}), async (req, res, next) => {
    try {
        const { limit, page } = req.query;
        const courses = await req.service.listCourses({ limit, page });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Courses fetched successfully",
            data: courses
        });
    } catch (err) {
        next(err);
    }
});

router.get("/search", validate({
    content: "isString",
    limit: `isNumeric&optional=${JSON.stringify({ nullable: true })}`,
}), async (req, res, next) => {
    try {
        let { content, limit, page } = req.query;
        content = String(atob(content));
        const courses = await req.service.searchCourses({ content, limit, page });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Courses fetched successfully",
            data: courses
        });
    } catch (err) {
        next(err);
    }
});

router.get("/highlight", async (req, res, next) => {
    try {
        let { limit, min_rate } = req.query;
        const courses = await req.service.listHighlightCourses({
            limit,
            min_rating: min_rate
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Courses fetched successfully",
            data: courses
        });
    } catch (err) {
        next(err);
    }
})

router.get("/filter", async (req, res, next) => {
    try {
        let { teacher_name, teacher_exp, tag, limit, page, teacher_edulevel } = req.query;
        const courses = await req.service.filterCourses({
            teacher_name, teacher_exp, tag, limit, page, teacher_edulevel
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Courses fetched successfully",
            data: courses
        });
    } catch (err) {
        next(err);
    }
})

router.get("/mine", async (req, res, next) => {
    try {
        let { page, limit } = req.query;
        const courses = await req.service.listMyCourses({
            page,
            limit
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Courses fetched successfully",
            data: courses
        });
    } catch (err) {
        next(err);
    }
});

router.get("/:id", async (req, res, next) => {
    try {
        let isSlug = !isUUID(String(req.params.id));
        const course = await req.service.findCourse({
            id: String(req.params.id),
            isSlug
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Course fetched successfully",
            data: course
        });
    } catch (err) {
        next(err);
    }
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
}), async (req, res, next) => {
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
    try {
        await req.service.createCourse({
            courseData: {
                title,
                type,
                description,
                level,
                thumbnail_url,
                headline,
                content_info,
                amount_price,
                currency,
            },
            acl: [UserRole.TEACHER]
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_201_CREATED,
            message: "Course created successfully",
        });
    } catch (err) {
        next(err);
    }
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
}), async (req, res, next) => {
    try {
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
        await req.service.updateCourse({
            courseId,
            updateObj: {
                type,
                description,
                level,
                thumbnail_url,
                headline,
                content_info,
                amount_price,
                currency,
            },
            resourceId: courseId,
            actionType: ActionType.UPDATE
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Course updated successfully",
        });
    } catch (err) {
        next(err);
    }
});

router.delete("/:id", async (req, res, next) => {
    try {
        if (!isUUID(String(req.params.id))) {
            return wrapResponse(res, {
                code: STATUS_CODE.HTTP_400_BAD_REQUEST,
                message: "Invalid course id"
            });
        }
        let courseId = String(req.params.id);
        await req.service.deleteCourse({
            courseId,
            resourceId: courseId,
            actionType: ActionType.DELETE
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Course deleted successfully",
        });
    } catch (err) {
        next(err);
    }
});

router.get("/:id/lesson", async (req, res, next) => {
    try {
        let { id } = req.params;
        id = String(id);
        let isSlug = !isUUID(id);
        const lessons = await req.service.listLessons({ courseId: id, isSlug });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Lessons fetched successfully",
            data: lessons
        });
    } catch (err) {
        next(err);
    }
});

router.post("/:id/lesson", validate({
    title: "isString",
    description: "isString",
}), async (req, res, next) => {
    try {
        let { id } = req.params;
        if (!isUUID(id)) {
            return wrapResponse(res, {
                code: STATUS_CODE.HTTP_400_BAD_REQUEST,
                message: "Invalid course id"
            });
        }
        id = String(id);
        let { title, description } = req.body;
        const lesson = await req.service.createLesson({
            courseId: id,
            lessonData: {
                title,
                description,
            },
            resourceId: id,
            actionType: ActionType.UPDATE
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_201_CREATED,
            message: "Lesson created successfully",
            data: lesson
        });
    } catch (err) {
        next(err);
    }
});

router.patch("/lesson/:lessonId", validate({
    title: `isString&optional=${JSON.stringify({ nullable: true })}`,
    description: `isString&optional=${JSON.stringify({ nullable: true })}`,
}), async (req, res, next) => {
    try {
        let { lessonId } = req.params;
        if (!isUUID(lessonId)) {
            return wrapResponse(res, {
                code: STATUS_CODE.HTTP_400_BAD_REQUEST,
                message: "Invalid lesson id"
            });
        }
        let { title, description } = req.body;
        const lesson = await req.service.updateLesson({
            lessonId,
            updateObj: {
                title,
                description,
            },
            resourceId: lessonId,
            actionType: ActionType.UPDATE
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Lesson updated successfully",
            data: lesson
        });
    } catch (err) {
        next(err);
    }
});

router.post("/:id/review", validate({
    comment: "isString",
    rating: "isNumeric"
}), async (req, res, next) => {
    try {
        let { id } = req.params;
        id = String(id);
        let isSlug = !isUUID(id);
        let { comment, rating } = req.body;
        await req.service.createCourseReview({
            courseId: id,
            reviewData: {
                comment,
                rating
            },
            isSlug,
            acl: [UserRole.STUDENT]
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_201_CREATED,
            message: "Review created successfully",
        });
    } catch (err) {
        next(err);
    }
});

router.get("/:id/join", async (req, res, next) => {
    try {
        let { id } = req.params;
        id = String(id);
        let isSlug = !isUUID(id);
        await req.service.joinCourse({
            courseId: id,
            isSlug,
            acl: [UserRole.STUDENT]
        });
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_200_OK,
            message: "Join course successfully",
        });
    } catch (err) {
        next(err);
    }
});

module.exports = router;
