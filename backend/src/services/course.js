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
        page = page ? Math.abs(page) * (limit - 1) : 0;
        const { rows: courses, error } = await this._courseRepo.findInTable({
            table: "courses",
            limit,
            page
        });
        if (error) {
            throw new Error(error);
        }
        return courses;
    }

    async findCourse({ id, isSlug = false }) {
        let findObj = isSlug ? { course_slug: id } : { course_id: id };
        const { row: course, error } = await this._courseRepo.findOneInTable({
            table: "courses",
            findObj
        });
        if (error) {
            throw new Error(error);
        }
        return course;
    }

    async listLessons({ courseId, isSlug = false }) {
        if (isSlug) {
            const { row: course, error } = await this._courseRepo.findOneInTable({
                table: "courses",
                findObj: { course_slug: courseId }
            });
            if (error) {
                throw new Error(error);
            }
            courseId = course.course_id;
        }
        const { rows: lessons, error } = await this._courseRepo.findInTable({
            table: "lessons",
            findObj: { course_id: courseId }
        });
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
        const { row: lesson, error } = await this._courseRepo.createInTable({
            table: "lessons",
            createObj: {
                id: uuidv4(),
                title,
                description,
                course_id: courseId
            }
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
        const { rows: lessons, error } = await this._courseRepo.updateInTable({
            table: "lessons",
            indentify: {
                id: lessonId
            },
            updateObj: {
                title,
                description
            }
        });
        if (error) {
            throw new Error(error);
        }
        return lessons[0];
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
        const { row: course, error } = await this._courseRepo.createInTable({
            table: "courses",
            createObj: {
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
            }
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
        const { rows: courses, error } = await this._courseRepo.updateInTable({
            table: "courses",
            indentify: {
                course_id: courseId
            },
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
        });
        if (error) {
            throw new Error(error);
        }
        return courses[0];
    }

    async searchCourses({ content, limit }) {
        limit = limit ? Math.abs(limit) : 20;
        const { courses, error } = await this._courseRepo.search({ content, limit });
        if (error) {
            throw new Error(error);
        }
        return courses;
    };

    async createCourseReview({
        courseId,
        reviewData: {
            rating,
            comment
        }, isSlug
    }) {
        let studentBoughtCourses = await this._courseRepo.findStudentCourses({
            studentId: this._currentUser.id
        });
        let course;
        course = studentBoughtCourses.find(c => {
            if (isSlug) {
                return c.course_slug === courseId;
            }
            return c.course_id === courseId;
        });
        if (!course) {
            throw new Error("You have not bought this course");
        }

        let { row: review, error } = await this._courseRepo.createInTable({
            table: "reviews",
            createObj: {
                rating,
                comment,
                course_id: course.course_id,
                student_id: this._currentUser.id
            }
        });

        if (error) {
            throw new Error(error);
        }
        return review;
    }

    async joinCourse({ courseId, isSlug }) {
        let course;
        if (isSlug) {
            course = await this._courseRepo.findOneInTable({
                table: "courses",
                findObj: { course_slug: courseId }
            });
            if (course.error) {
                throw new Error(course.error);
            }
            course = course.row;
        } else {
            course = await this._courseRepo.findOneInTable({
                table: "courses",
                findObj: { course_id: courseId }
            });
            if (course.error) {
                throw new Error(course.error);
            }
            course = course.row;
        }

        let { row: join, error } = await this._courseRepo.createInTable({
            table: "students_join_course",
            createObj: {
                course_id: course.course_id,
                student_id: this._currentUser.id,
                current_price: course.amount_price,
            }
        });

        if (error) {
            throw new Error(error);
        }
        return join;

    }
}

module.exports = {
    CourseService
};