const { IService } = require("../utils/service");
const { CourseRepo } = require("../repository/course");

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

    async getCourseById(id) {
        const { course, err } = await this._courseRepo.findOne({ course_id: id });
        if (err) {
            throw new Error(err);
        }
        return course;
    }
}

module.exports = {
    CourseService
};