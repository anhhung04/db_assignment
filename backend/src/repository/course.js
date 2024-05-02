const { IRepo } = require("./index");
const logger = require("../utils/log");

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

    async findStudentCourses({ studentId }) {
        try {
            const result = await this.exec({
                query: `
                    SELECT c.*, j.current_price as buy_price, j.created_at as buy_at
                    FROM students_join_course j
                    JOIN courses c ON students_join_course.course_id = courses.course_id AND students_join_course.student_id = $1;
                `,
                args: [studentId]
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
}

module.exports = {
    CourseRepo
};