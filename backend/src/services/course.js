const { IService } = require("../utils/service");
const { CourseRepo } = require("../repository/course");
const { v4: uuidv4 } = require('uuid');

class CourseService extends IService {
    constructor(request) {
        super(request);
        this._courseRepo = new CourseRepo();
    }
    async listCourses({ limit, page }) {
        limit = limit ? Math.abs(limit) : 10;
        let offset = page ? Math.abs(page) * (limit - 1) : 0;
        const { courses, error } = await this._courseRepo.find({ limit, offset });
        if (error) {
            throw new Error(error);
        }
        return courses;
    }

    async findCourse({ id, isSlug = false }) {
        let findObj = isSlug ? { course_slug: id } : { course_id: id };
        const { course, error } = await this._courseRepo.findOne(findObj);
        if (error) {
            throw new Error(error);
        }
        return course;
    }

    async listLessons({ courseId, isSlug = false }) {
        if (isSlug) {
            const { course, error } = await this._courseRepo.findOne({ course_slug: courseId });
            if (error) {
                throw new Error(error);
            }
            courseId = course.course_id;
        }
        const { lessons, error } = await this._courseRepo.findLessons(courseId);
        if (error) {
            throw new Error(error);
        }
        return lessons;
    }

    async createLesson({
        courseId,
        lessonData: {
            title,
            description,
        },
    }) {
        const { lesson, error } = await this._courseRepo.createLesson({
            id: uuidv4(),
            title,
            description,
            course_id: courseId
        });
        if (error) {
            throw new Error(error);
        }
        await this._courseRepo.modifyPermission({
            userId: this._currentUser.id,
            resourceId: lesson.id,
            permissions: {
                create: true,
                read: true,
                update: true,
                delete: true
            }, newPermissions: true
        });
        return lesson;
    }

    async updateLesson({
        lessonId,
        updateObj: {
            title,
            description,
        }
    }) {
        const { lesson, error } = await this._courseRepo.updateLesson(lessonId, {
            title,
            description
        });
        if (error) {
            throw new Error(error);
        }
        return lesson;
    }

    async createCourse({
        courseData: {
            title,
            type,
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency
        }
    }) {
        let course_slug = title.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-zA-Z0-9 ]/g, "").replace(/ /g, "-").toLowerCase();
        course_slug = course_slug + "-" + Math.random().toString(36).substring(2, 7);
        const { course, error } = await this._courseRepo.create({
            course_id: uuidv4(),
            title,
            type,
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency,
            course_slug
        });
        if (error) {
            throw new Error(error);
        }
        await this._courseRepo.modifyPermission({
            userId: this._currentUser.id,
            resourceId: course.course_id,
            permissions: {
                create: true,
                read: true,
                update: true,
                delete: true
            }, newPermissions: true
        });
        return course;
    }

    async updateCourse({
        courseId,
        updateObj: {
            type,
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency
        }
    }) {
        const { course, error } = await this._courseRepo.findByIdAndUpdate(courseId, {
            type,
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency
        });
        if (error) {
            throw new Error(error);
        }
        return course;
    }

    async searchCourses({ content, limit }) {
        limit = limit ? Math.abs(limit) : 20;
        const { courses, error } = await this._courseRepo.search({ content, limit });
        if (error) {
            throw new Error(error);
        }
        return courses;
    };
}

module.exports = {
    CourseService
};