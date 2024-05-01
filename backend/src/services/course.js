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
        const { courses, err } = await this._courseRepo.find({ limit, offset });
        if (err) {
            throw new Error(err);
        }
        return courses;
    }

    async findCourse(id, isSlug = false) {
        let findObj = isSlug ? { course_slug: id } : { course_id: id };
        const { course, err } = await this._courseRepo.findOne(findObj);
        if (err) {
            throw new Error(err);
        }
        return course;
    }

    async createCourse({
        title,
        type,
        description,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency
    }) {
        let course_slug = title.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-zA-Z0-9 ]/g, "").replace(/ /g, "-").toLowerCase();
        course_slug = course_slug + "-" + Math.random().toString(36).substring(2, 7);
        const { course, err } = await this._courseRepo.create({
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
        if (err) {
            throw new Error(err);
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

    async updateCourse(id, {
        type,
        description,
        level,
        thumbnail_url,
        headline,
        content_info,
        amount_price,
        currency
    }) {
        const { course, err } = await this._courseRepo.findByIdAndUpdate(id, {
            type,
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency
        });
        if (err) {
            throw new Error(err);
        }
        return course;
    }

    async searchCourses({ content, limit }) {
        limit = limit ? Math.abs(limit) : 20;
        const { courses, err } = await this._courseRepo.search({ content, limit });
        if (err) {
            throw new Error(err);
        }
        return courses;
    };
}

module.exports = {
    CourseService
};