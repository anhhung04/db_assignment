const { IService } = require("../utils/service");
const { CourseRepo } = require("../repository/course");
const { v4: uuidv4 } = require('uuid');
const logger = require("../utils/log");

class CourseService extends IService {
    constructor(request) {
        super(request);
        this._courseRepo = new CourseRepo();
    }
    async listCourses({ limit, page }) {
        limit = limit ? Math.abs(limit) : 10;
        page = page ? Math.abs(page) : 1;
        const { rows: courses, error } = await this._courseRepo.exec({
            query: `
                SELECT c.*, u.*
                FROM courses c
                JOIN users u ON c.teacher_id = u.id
                LIMIT $1 OFFSET $2;
            `,
            args: [limit, (page - 1) * limit]
        });
        if (error) {
            throw new Error(error);
        }
        return courses.map(r => ({
            course_id: r.course_id,
            course_slug: r.course_slug,
            title: r.title,
            type: r.type,
            description: r.description,
            level: r.level,
            thumbnail_url: r.thumbnail_url,
            headline: r.headline,
            content_info: r.content_info,
            amount_price: r.amount_price,
            currency: r.currency,
            total_students: r.total_students,
            rating: r.rating,
            teacher: {
                id: r.teacher_id,
                display_name: r.display_name,
                avatar_url: r.avatar_url
            }
        }));
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
        let reviewResults = await this._courseRepo.exec({
            query: `
                SELECT r.*, u.*
                FROM reviews r
                JOIN users u ON r.student_id = u.id
                WHERE r.course_id = $1;
            `,
            args: [course.course_id]
        });
        reviewResults = reviewResults?.rows ? reviewResults.rows.map(row => ({
            comment: row.comment,
            student_rate: row.rating,
            student: {
                id: row.id,
                display_name: row.display_name,
                avatar_url: row.avatar_url
            }
        })) : [];
        course.lessons = lessons;
        course.reviews = reviewResults;
        if (this._currentUser && this._currentUser.role == "student") {
            let results = await this._courseRepo.exec({
                query: `SELECT * FROM calculate_course_price($1, $2);`,
                args: [this._currentUser.id, course.course_id]
            });
            course.price = results.rows[0];
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
            teacherId: this._currentUser.id
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
        try {
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
            await this._courseRepo.exec({
                query: `CALL rate_course($1, $2, $3, $4);`,
                args: [courseId, this._currentUser.id, comment, rating]
            });
        } catch (err) {
            logger.debug(err);
            throw new Error(err);
        }
    }

    async joinCourse({ courseId, isSlug }) {
        let { rows, error: err } = await this._courseRepo.findInTable({
            table: "courses",
            findObj: isSlug ? { course_slug: courseId } : {
                course_id: courseId
            }
        });
        if (err) {
            throw new Error("Course not found");
        }
        let { error } = await this._courseRepo.joinCourse({
            studentId: this._currentUser.id,
            courseId: rows[0].course_id
        });

        if (error) {
            throw new Error(error);
        }
    }

    async filterCourses({
        teacher_name,
        teacher_exp,
        tag,
        limit,
        page,
        teacher_edulevel
    }) {
        teacher_name = teacher_name && typeof teacher_name == "string" ? teacher_name : "";
        teacher_exp = teacher_exp && typeof teacher_exp == "number" ? teacher_exp : 0;
        teacher_edulevel = teacher_edulevel && typeof teacher_edulevel == "string" ? teacher_edulevel : "";
        tag = tag && typeof tag == "string" ? tag : "";
        limit = limit ? Math.abs(limit) : 5;
        page = page ? Math.abs(page) : 1;
        try {
            let results = await this._courseRepo.exec({
                query: `
                    SELECT * FROM filter_courses($1, $2, $3, $4, $5, $6);
                `,
                args: [tag, teacher_name, teacher_exp, teacher_edulevel, limit, page]
            });
            return results.rows.map(row => ({
                course_id: row.course_id,
                title: row.title,
                description: row.description,
                level: row.level,
                thumbnail_url: row.thumbnail_url,
                headline: row.headline,
                content_info: row.content_info,
                amount_price: row.amount_price,
                currency: row.currency,
                total_students: row.total_students,
                course_slug: row.course_slug,
                type: row.type,
                rating: row.rating,
                teacher: {
                    display_name: row.teacher_name,
                    id: row.teacher_id,
                    avatar_url: row.teacher_avatar,
                    educational_level: row.teacher_edu_level
                }
            }));
        } catch (err) {
            logger.debug(err);
            throw new Error(err);
        }
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
        courses = courses.map(async (course) => {
            let teacherResult = await this._courseRepo.exec({
                query: `SELECT * FROM users WHERE id = $1;`,
                args: [course.teacher_id]
            });
            if (teacherResult.rows[0]) {
                course.teacher = {
                    id: teacherResult.rows[0].id,
                    display_name: teacherResult.rows[0].display_name,
                    avatar_url: teacherResult.rows[0].avatar_url
                };
            };
            return course;
        });
        courses = await Promise.all(courses);
        return courses;
    }

    async listHighlightCourses({ limit, min_rating }) {
        limit = limit ? Math.abs(limit) : 10;
        min_rating = min_rating ? Math.abs(min_rating) : 0;
        const result = await this._courseRepo.exec(
            {
                query: `
                    SELECT * FROM get_top_highlight_courses($1, $2);
                `,
                args: [limit, min_rating]
            }
        );
        return result.rows.map(row => ({
            course_id: row.course_id,
            course_slug: row.course_slug,
            title: row.title,
            description: row.description,
            level: row.level,
            thumbnail_url: row.thumbnail_url,
            headline: row.headline,
            content_info: row.content_info,
            amount_price: row.amount_price,
            currency: row.currency,
            total_students: row.total_students,
            rating: row.rating,
            total_reviews: row.total_reviews,
            teacher: {
                id: row.teacher_id,
                avatar_url: row.teacher_avatar,
                display_name: row.teacher_name
            }
        }));
    }
}

module.exports = {
    CourseService
};
