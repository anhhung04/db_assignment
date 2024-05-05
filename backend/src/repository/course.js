const { IRepo } = require("./index");
const logger = require("../utils/log");
const { convertObjectToFilterQuery } = require("../utils/db");

class CourseRepo extends IRepo {
    constructor() {
        super();
    }

    async search({ content, limit }) {
        try {
            const result = await this.exec({
                query: `
                    SELECT * FROM courses
                    WHERE title LIKE $1 OR description LIKE $1 OR content_info LIKE $1
                    LIMIT $2;
                `,
                args: [`%${content}%`, limit]
            });
            return {
                courses: result.rows,
                error: null
            };
        }
        catch (err) {
            logger.debug(err);
            return {
                courses: [],
                error: err
            };
        }
    }

    async findOne(findObj) {
        try {
            let { filterQuery, args } = convertObjectToFilterQuery(findObj);
            const result = await this.exec({
                query: `
                SELECT 
                    c.*,
                    u.*
                FROM 
                    courses c
                JOIN 
                    users u ON c.teacher_id = u.id
                WHERE ${filterQuery};
                `,
                args
            });
            return {
                course: {
                    course_id: result.rows[0].course_id,
                    course_slug: result.rows[0].course_slug,
                    title: result.rows[0].title,
                    type: result.rows[0].type,
                    description: result.rows[0].description,
                    level: result.rows[0].level,
                    thumbnail_url: result.rows[0].thumbnail_url,
                    headline: result.rows[0].headline,
                    content_info: result.rows[0].content_info,
                    amount_price: result.rows[0].amount_price,
                    currency: result.rows[0].currency,
                    teacher: {
                        id: result.rows[0].id,
                        username: result.rows[0].username,
                        email: result.rows[0].email,
                        avatar_url: result.rows[0].avatar_url,
                        fname: result.rows[0].fname,
                        lname: result.rows[0].lname,
                    },
                },
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                course: null,
                error: err
            };
        }
    }

    async findStudentCourses({ studentId, courseId, isSlug = false }) {
        try {
            const result = await this.exec({
                query: `
                    SELECT c.*, j.current_price as buy_price, j.created_at as buy_at
                    FROM students_join_course j
                    JOIN courses c ON students_join_course.course_id = courses.course_id AND students_join_course.student_id = $1${courseId ? ` WHERE ${isSlug ? "course_slug" : "course_id"} = $2` : ""};
                `,
                args: [studentId, courseId]
            });
            return {
                courses: result.rows,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                courses: [],
                error: err
            };
        }
    }

    async calculatePayment({ studentId, courseId }) {
        try {
            const result = await this.exec({
                query: `
                    CALL calculate_payment($1, $2);
                `,
                args: [studentId, courseId]
            });
            if (result.rows[0].length !== 1) {
                return {
                    error: "Course not found"
                };
            }
            return {
                course: result.rows[0][0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                course: null,
                error: err
            };
        }
    }

    async reviewCourse({ courseId, rating, comment, studentId }) {
        try {
            await this.exec({
                query: `
                    CALL review_course($1, $2, $3, $4);
                `,
                args: [courseId, studentId, rating, comment]
            });
            return {
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                error: err
            };
        }

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
        currency,
    }) {
        try {
            let course_slug = title.normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-zA-Z0-9 ]/g, "").replace(/ /g, "-").toLowerCase();
            course_slug = course_slug + "-" + Math.random().toString(36).substring(2, 7);
            await this.exec({
                query: `
                    CALL insert_courses($1, $2, $3, $4, $5, $6, $7, $8, $9, $10);
                `,
                args: [title, type, description, level, thumbnail_url, headline, content_info, amount_price, currency, course_slug]
            });
            return {
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                error: err
            };
        }
    }

    async update({
        courseId,
        updateObj: {
            description,
            level,
            thumbnail_url,
            headline,
            content_info,
            amount_price,
            currency
        }
    }) {
        try {
            await this.exec({
                query: `
                    CALL update_courses($1, $2, $3, $4, $5, $6, $7, $8);
                `,
                args: [courseId, description, level, thumbnail_url, headline, content_info, amount_price, currency]
            });
            return {
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                error: err
            };
        }
    }

    async delete({ courseId }) {
        try {
            const result = await this.exec({
                query: `
                    CALL delete_courses($1);
                `,
                args: [courseId]
            });
            return {
                course: result.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                course: null,
                error: err
            };
        }
    }

    async getHightlightCourses({ min_rating = 0.0, limit }) {
        try {
            const result = await this.exec({
                query: `
                    SELECT * FROM get_top_highlight_courses($1, $2);
                `,
                args: [limit, min_rating]
            });
            return {
                courses: result.rows,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                courses: [],
                error: err
            };
        }
    }
}

module.exports = {
    CourseRepo
};