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
        page = page ? Math.abs(page) : 0;
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
        const { course, error } = await this._courseRepo.findOne(findObj);
        if (error) {
            throw new Error(error);
        }
        if (!course) {
            throw new Error("Course not found");
        }
        let { rows: lessons, error: err } = await this._courseRepo.findInTable({
            table: "lessons",
            findObj: { course_id: course.course_id }
        });
        if (err) {
            throw new Error(err);
        }
        lessons = lessons.map(lesson => {
            delete lesson.course_id;
            return lesson;
        });
        course.lessons = lessons;
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
        for (let i = 0; i < lessons.length; i++) {
            let { rows: resources, error: err } = await this._courseRepo.findInTable({
                table: "lesson_resources",
                findObj: { lesson_id: lessons[i].id }
            });
            if (err) {
                throw new Error(err);
            }
            lessons[i].resources = resources;
        }
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
        const { error } = await this._courseRepo.createCourse({
            title,
            type,
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency,
        });
        if (error) {
            throw new Error(error);
        }
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
        const { error } = await this._courseRepo.update({
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
        });
        if (error) {
            throw new Error(error);
        }
    }

    async deleteCourse({ courseId }) {
        const { error } = await this._courseRepo.delete({
            courseId
        });
        if (error) {
            throw new Error(error);
        }
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
        let studentBoughtCourse = await this._courseRepo.findStudentCourses({
            studentId: this._currentUser.id,
            courseId,
            isSlug
        });
        if (!studentBoughtCourse[0]) {
            throw new Error("You have not bought this course");
        }

        let { error } = await this._courseRepo.reviewCourse({
            studentId: this._currentUser.id,
            courseId: studentBoughtCourse[0].course_id,
            rating,
            comment
        });

        if (error) {
            throw new Error(error);
        }
    }

    async joinCourse({ courseId, isSlug }) {
        let { row: course, error } = await this._courseRepo.findOneInTable({
            table: "courses",
            findObj: {
                [`${isSlug ? "course_slug" : "course_id"}`]: courseId
            }
        });

        if (error) {
            throw new Error(error);
        }

        let { row: join, error: err } = await this._courseRepo.createInTable({
            table: "students_join_course",
            createObj: {
                course_id: course.course_id,
                student_id: this._currentUser.id,
                current_price: course.amount_price,
            }
        });

        if (err) {
            throw new Error(err);
        }

        return join;
    }

    async listMyCourses({
        limit,
        page
    }) {
        let courses = [];
        if (!this._currentUser) {
            throw new Error("You are not logged in");
        }
        if (this._currentUser.role == "student") {
            let result = await this._courseRepo.findStudentCourses({
                studentId: this._currentUser.id,
                limit,
                page
            });
            if (result.error) {
                throw new Error(result.error);
            }
            courses = result.courses;
        } else if (this._currentUser.role == "teacher") {
            let result = await this._courseRepo.findInTable({
                table: "courses",
                findObj: {
                    teacher_id: this._currentUser.id
                },
                limit,
                page
            });
            if (result.error) {
                throw new Error(result.error);
            }
            courses = result.rows;
        } else {
            throw new Error("You are not a student or teacher");
        }
        return courses;
    }

    async listHighlightCourses({ limit, min_rating }) {
        limit = limit ? Math.abs(limit) : 10;
        min_rating = min_rating ? Math.abs(min_rating) : 0;
        const { courses, error } = await this._courseRepo.getHightlightCourses({
            limit,
            min_rating
        });
        if (error) {
            throw new Error(error);
        }
        return courses;
    }
}

module.exports = {
    CourseService
};